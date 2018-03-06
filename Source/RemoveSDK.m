//
//  GPHSDKQuery.m
//  Giphy
//
//  Created by Cem Kozinoglu on 5/15/17.
//  Copyright © 2017 Giphy. All rights reserved.
//


//#define DEBUG = 1

static const NSInteger kDefaultRequestNumberOfImages = 50;
static const NSUInteger kRequestNumberOfChannels = 50;

@interface GPHSDKQuery () <GPHConnectionStatusObserver>

@property (nonatomic) NSMutableArray *updateBlocks;
@property (nonatomic) NSTimer *retryTimer;
// A counter recording the number of sequential failures that have
// occurred since the last success.
@property (nonatomic) int retryCount;

@property (nonatomic) GPHSDKQuery *suggestionSubquery;
@property (nonatomic) NSUInteger nextOffset;
@property (nonatomic) NSDate *lastRequestStartedAt;
@property (nonatomic) NSInteger lastRequestResultCount;
@property (nonatomic) BOOL hasRequestInFlight;

@end


@implementation GPHSDKQuery

- (instancetype)init {
    if (self = [super init]) {
        [[GPHConnectionStatus instance] addObserver:self];
        self.requestNumberOfImages = kDefaultRequestNumberOfImages;
    }
    
    return self;
}

- (void)addUpdateBlock:(GPHSDKQueryUpdateBlock)updateBlock {
    GPHAssert([NSThread isMainThread]);
    GPHAssert(updateBlock);
    
    if (!_updateBlocks) {
        _updateBlocks = [NSMutableArray new];
    }
    [_updateBlocks addObject:updateBlock];
}

- (void)fireDelegateUpdate {
    GPHAssert([NSThread isMainThread]);
    
    for (GPHSDKQueryUpdateBlock updateBlock in _updateBlocks) {
        updateBlock(self);
    }
}

- (void)tryToScheduleARetry {
    if (self.retryTimer) {
        // A retry is already scheduled, so ignore.
        return;
    }
    
    ++self.retryCount;
    GPHAssert(self.retryCount > 0);
    
    // Our retry adopts a simple "exponential backoff" algorithm.
    // Essentially we wait for the square of the retry count, in seconds,
    // although we could tune this if we wanted to.
    // e.g. After the first failure, we wait 1 second,
    // after the second we wait 4 seconds,
    // after the third we wait 9 seconds, etc.
    //
    // It'd be nice to eventually honor connectivity (via Reachability)
    // and foreground/activation state, but this isn't convenient
    // in our codebase yet and it shouldn't be a big deal.
    static const CGFloat kRetryDelayConstant = 1.f;
    static const CGFloat kRetryDelayPower = 2.f;
    NSTimeInterval retryDelaySeconds = kRetryDelayConstant * pow((CGFloat) self.retryCount, kRetryDelayPower);
    self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:retryDelaySeconds
                                                       target:self
                                                     selector:@selector(newRequestFired:)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)newRequestFired:(id)ignore {
    [self newRequest:YES];
}

- (void)cancelRetry {
    [self.retryTimer invalidate];
    self.retryTimer = nil;
}

- (void)removeItemAtIndex:(NSInteger)index {
    GPHAssert(self.queryType == SDKQueryTypeFavorites);
    GPHAssert(index >= 0 && index < self.items.count);
    
    if (self.queryType == SDKQueryTypeFavorites &&
        index >= 0 &&
        index < self.items.count) {
        NSMutableArray *items = [self.items mutableCopy];
        [items removeObjectAtIndex:index];
        self.items = items;
        
        [self fireDelegateUpdate];
    }
}

- (void)resetRequest:(BOOL)fireEventImmediately {
    self.items = @[];
    [self.retryTimer invalidate];
    self.retryTimer = nil;
    self.suggestionSubquery = nil;
    self.hasReceivedAResponse = NO;
    self.hasReceivedAFailure = NO;
    self.hasReceivedEmptyResponse = NO;
    self.totalResultCount = nil;
    self.nextOffset = 0;
    self.hasRequestInFlight = NO;
    self.lastRequestStartedAt = nil;
    self.lastRequestResultCount = 0;
    
    [self newRequest:YES];
    
    if (fireEventImmediately) {
        [self fireDelegateUpdate];
    }
}

- (BOOL)hasAlreadyReturnedAllResults {
    return (([self totalResultCount] != nil) && (self.nextOffset >= [self.totalResultCount integerValue]));
    
    return self.hasReceivedEmptyResponse;
}

- (void)handleListMediaResponse:(GPHListMediaResponse *)response error:(NSError *)error successBlock:(GPHFetchGIFListSuccessBlock)successBlock failureBlock:(GPHFailureBlock)failureBlock {
    
    if (error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failureBlock(nil, error);
        });
        return;
    }

    NSMutableArray *data = [NSMutableArray array];
    for (GPHMedia *mediaObj in response.data) {
        [data addObject:mediaObj];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        successBlock(data, response.pagination.filteredCount, response.pagination.totalCount, response.meta.responseId);
    });
}


- (BOOL)newRequest:(BOOL)force {
    if (force) {
        [self cancelRetry];
        self.hasRequestInFlight = NO;
    }
    
    if (self.retryTimer) {
        // There already is a pending request, abort.
        return false;
    }
    
    if (self.hasRequestInFlight) {
        // There already is a request in flight.
        return false;
    }
    
    if (self.queryType == SDKQueryTypeLocalResults) {
        
        self.hasRequestInFlight = NO;
        [self cancelRetry];
        self.retryCount = 0;
        self.hasReceivedAFailure = NO;
        self.hasReceivedAResponse = YES;
        self.totalResultCount = @(_items.count);
        
        if (_items.count == 0) {
            self.hasReceivedEmptyResponse = YES;
        }
        
        return true;
    }
    
    self.hasRequestInFlight = YES;
    self.lastRequestStartedAt = [NSDate date];
    self.lastRequestResultCount = 0;
    NSUInteger offsetAtRequestStart = self.nextOffset;
    
    if ([self hasAlreadyReturnedAllResults]) {
        return false;
    }
    
    __weak GPHSDKQuery *welf = self;
    GPHFetchGIFListSuccessBlock successBlock = ^(NSArray *results, long filteredCount, long totalResultCount, NSString *responseId) {
        GPHAssert([NSThread isMainThread]);
        
        GPHSDKQuery *strelf = welf;
        if (!strelf) {
            return;
        }
        
        self.hasRequestInFlight = NO;
        [strelf cancelRetry];
        strelf.retryCount = 0;
        
        strelf.hasReceivedAFailure = NO;
        
        if (strelf.nextOffset != offsetAtRequestStart) {
            // If another request has modified items since this
            // request began, ignore this response.
            return;
        }
        
        // Append.
        NSMutableArray *existingSet = strelf.items ? [strelf.items mutableCopy] : [NSMutableArray array];
        NSMutableSet *uniqueIdSet = [NSMutableSet set];
        
        // Assert that our existing set is already de-duplicated
        for (id item in existingSet) {
            if ([item respondsToSelector:@selector(hash)]) {
                GPHAssert(![uniqueIdSet containsObject:@([item hash])]);
                [uniqueIdSet addObject:@([item hash])];
            }
        }
        
        // The Giphy API doesn't provide a "consistent" paging mechanism, so
        // we deduplicate all responses by "unique id".
        for (id item in results) {
            if (![uniqueIdSet containsObject:@([item hash])]) {
                [existingSet addObject:item];
                [uniqueIdSet addObject:@([item hash])];
            }
        }
        
        if ([existingSet count] < 1 &&
            !strelf.hasReceivedAResponse &&
            strelf.queryType == SDKQueryTypeSearch &&
            !strelf.suggestionSubquery) {
            // If a search query returns no results, initiate a subquery to find
            // suggested alternative queries.
            strelf.suggestionSubquery = [GPHSDKQuery suggestionSubqueryForString:strelf.searchQuery];
            [strelf.suggestionSubquery addUpdateBlock:^(GPHSDKQuery *query) {
                if (welf.suggestionSubquery != query) {
                    return;
                }
                
                // Propagate events from subqueries.
                [welf fireDelegateUpdate];
            }];
            [strelf.suggestionSubquery newRequest:YES];
        }
        
        strelf.items = existingSet;
        strelf.hasReceivedAResponse = YES;
        
        strelf.lastRequestResultCount = results.count;
        
        if (!strelf.totalResultCount) {
            strelf.totalResultCount = @(totalResultCount);
        }
        if (results.count == 0) {
            strelf.hasReceivedEmptyResponse = YES;
        }
        strelf.nextOffset = offsetAtRequestStart + self.requestNumberOfImages;
        strelf.responseId = responseId;
        
        [strelf fireDelegateUpdate];
    };
    
    GPHFailureBlock failureBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        GPHAssert([NSThread isMainThread]);
        
        
        GPHSDKQuery *strelf = welf;
        if (!strelf) {
            return;
        }
        
        self.hasRequestInFlight = NO;
        [strelf tryToScheduleARetry];
        strelf.hasReceivedAFailure = YES;
        [strelf fireDelegateUpdate];
    };
    
    __weak typeof(self) weakSelf = self;
    switch (self.queryType) {
            

            
        case SDKQueryTypeChannelChildren: {
            
            [[GiphyCore shared] channelChildren:self.channelId offset:offsetAtRequestStart limit:kRequestNumberOfChannels media:self.channelMediaType completionHandler:^(GPHListChannelResponse * response, NSError * error) {
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    
                    if (error != nil) {
                        failureBlock(nil, error);
                        return;
                    }
                    
#ifdef DEBUG_QUERY_RESPONSE_COUNTS
                    NSLog(@"%@", response.data);
#endif
                    
                    NSMutableArray *data = [NSMutableArray array];
                    for (GPHChannel *channelObj in response.data) {
                        [data addObject:channelObj];
                    }
                    
                    // Note that not all queries return `total_count`, so this may be nil.
                    
                    long filteredCount = response.data.count - data.count;
                    
                    successBlock(data, filteredCount, response.pagination.totalCount, response.meta.responseId);
                });
            }];
            
            break;
        }

    }
    
    return true;
}

#pragma mark - GPHConnectionStatusObserver

- (void)connectionStatusDidChange:(BOOL)isConnected {
    if (isConnected) {
        [self newRequest:NO];
    }
}



@end


