//
//  GPHStatefulRequest.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 3/6/18.
//  Copyright © 2018 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation
import UIKit

typealias GPHStatefulRequestUpdate = (_ request: GPHStatefulRequest) -> Void

@objc
class GPHStatefulRequest: GPHRequest {
    
    var requestUpdates: [GPHStatefulRequestUpdate]? = nil

    var totalResultCount = 0

    var nextRequestLimit = 25
    var nextRequestOffset = 0
    
    var lastRequestResultCount = 0
    var lastRequestStartedAt: Date? = nil
    
    var retryCount = 0
    var retryDelay = 1.0
    var retryDelayPower = 2.0
    var retryDelayTimer:Timer? = nil
    
    var hasRequestInFlight: Bool = false
    
    // This flag isn't set until we've receive at least a first response -
    // even if it was empty.
    var hasReceivedAResponse: Bool = false
    
    // This flag is set IFF we have received a failure more recently
    // than a response.
    var hasReceivedAFailure: Bool = false
    
    // This flag is set IFF we have received an empty response, which
    // should indicate that we have "bottomed out" in the paging.
    var hasReceivedEmptyResponse: Bool = false
    
    // More reliable way of determining whether the query has returned all paginated results
    var hasAlreadyReturnedAllResults: Bool {
        get { return totalResultCount > 0 && nextRequestOffset >= totalResultCount }
    }

    // Initiate a new request if necessary.
    //
    // 1) If force is YES, always create a new request.
    // 2) If force is NO, do not create a new request if there is already a pending retry.
    @discardableResult func newRequest(force: Bool) -> Bool {
        
        if force {
            cancelRetry()
            hasRequestInFlight = false
        }
        
        if retryDelayTimer != nil {
            // There already is a pending request, abort.
            return false
        }
        
        if hasRequestInFlight {
            // There already is a request in flight.
            return false
        }
        
        hasRequestInFlight = true
        lastRequestStartedAt = Date()
        lastRequestResultCount = 0
        let offsetAtRequestStart = nextRequestOffset
        
        if hasAlreadyReturnedAllResults {
            return false
        }
        
//        __weak GPHSDKQuery *welf = self;
//        GPHFetchGIFListSuccessBlock successBlock = ^(NSArray *results, long filteredCount, long totalResultCount, NSString *responseId) {
//
//            GPHSDKQuery *strelf = welf;
//            if (!strelf) {
//                return;
//            }
//
//            self.hasRequestInFlight = NO;
//            [strelf cancelRetry];
//            strelf.retryCount = 0;
//
//            strelf.hasReceivedAFailure = NO;
//
//            if (strelf.nextOffset != offsetAtRequestStart) {
//                // If another request has modified items since this
//                // request began, ignore this response.
//                return;
//            }
//
//
//            strelf.items = existingSet;
//            strelf.hasReceivedAResponse = YES;
//
//            strelf.lastRequestResultCount = results.count;
//
//            if (!strelf.totalResultCount) {
//                strelf.totalResultCount = @(totalResultCount);
//            }
//            if (results.count == 0) {
//                strelf.hasReceivedEmptyResponse = YES;
//            }
//            strelf.nextOffset = offsetAtRequestStart + self.requestNumberOfImages;
//            strelf.responseId = responseId;
//
//            [strelf fireDelegateUpdate];
//        };
//
//        GPHFailureBlock failureBlock = ^(NSURLSessionDataTask *task, NSError *error) {
//
//            GPHSDKQuery *strelf = welf;
//            if (!strelf) {
//                return;
//            }
//
//            self.hasRequestInFlight = NO;
//            [strelf tryToScheduleARetry];
//            strelf.hasReceivedAFailure = YES;
//            [strelf fireDelegateUpdate];
//        };
        
        return true
    }
    
    func resetRequest(fireEventImmediately: Bool) {
        
        retryDelayTimer?.invalidate()
        retryDelayTimer = nil
        hasReceivedAResponse = false
        hasReceivedEmptyResponse = false
        hasReceivedAFailure = false
        
        totalResultCount = 0
        nextRequestOffset = 0
        hasRequestInFlight = false
        
        lastRequestStartedAt = nil
        lastRequestResultCount = 0
        
        newRequest(force: true)
        
        if fireEventImmediately {
            fireRequestUpdate()
        }
        
    }
    
    
    func scheduleRetry() {
        
        if retryDelayTimer != nil {
            // A retry is already scheduled, so ignore.
            return;
        }
        
        retryCount += 1
        
        // Our retry adopts a simple "exponential backoff" algorithm.
        // Essentially we wait for the square of the retry count, in seconds,
        // although we could tune this if we wanted to.
        // e.g. After the first failure, we wait 1 second,
        // after the second we wait 4 seconds,
        // after the third we wait 9 seconds, etc.
        //
        // It'd be nice to eventually honor connectivity (via Reachability)
        // and foreground/activation state
        let retryDelaySeconds = retryDelay * pow(Double(retryCount), retryDelayPower)
        retryDelayTimer = Timer.scheduledTimer(timeInterval: retryDelaySeconds, target: self, selector: #selector(newRequestFired), userInfo: nil, repeats: false)

    }
    
    func cancelRetry() {
        retryDelayTimer?.invalidate()
        retryDelayTimer = nil
    }
    
    func fireRequestUpdate() {
        
//        let totalUpdates = (requestUpdates ?? []).count
//        print "COUNT: \(totalUpdates)"
        
        for update in requestUpdates ?? [] {
            update(self)
        }
    }
    
    func addUpdate(update: @escaping GPHStatefulRequestUpdate) {
    
        if requestUpdates == nil {
            requestUpdates = [];
        }
        requestUpdates?.append(update)
    }
    
    func newRequestFired() {
        newRequest(force: true)
    }

    
}


//- (instancetype)init {
//    if (self = [super init]) {
//        [[GPHConnectionStatus instance] addObserver:self];
//        self.requestNumberOfImages = kDefaultRequestNumberOfImages;
//    }
//
//    return self;
//}
//#pragma mark - GPHConnectionStatusObserver
//
//- (void)connectionStatusDidChange:(BOOL)isConnected {
//    if (isConnected) {
//        [self newRequest:NO];
//    }
//}
//
//

