//
//  GPHRequest.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman, Giorgia Marenda on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation

typealias GPHRequestUpdate = (_ request: GPHRequest) -> Void

/// Async Request Operations with Completion Handler Support
///
@objcMembers public class GPHRequest: GPHAsyncOperationWithCompletion {
    // MARK: Properties

    /// Config to form requests.
    var config: GPHRequestConfig
    
    /// The client to which this request is related.
    let client: GPHAbstractClient
    
    var requestUpdates: [GPHRequestUpdate]? = nil
    
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
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter client: GPHClient object to handle the request.
    /// - parameter config: GPHRequestConfig to formulate request(s).
    /// - parameter type: Request type (GPHRequestType).
    /// - parameter completionHandler: GPHJSONCompletionHandler to return JSON or Error.
    ///
    init(_ client: GPHAbstractClient, config: GPHRequestConfig, completionHandler: @escaping GPHJSONCompletionHandler) {
        self.client = client
        self.config = config
        super.init(completionHandler: completionHandler)
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
    
    func addUpdate(update: @escaping GPHRequestUpdate) {
        
        if requestUpdates == nil {
            requestUpdates = [];
        }
        requestUpdates?.append(update)
    }
    
    func newRequestFired() {
        newRequest(force: true)
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

        if hasAlreadyReturnedAllResults {
            return false
        }

        hasRequestInFlight = true
        lastRequestStartedAt = Date()
        lastRequestResultCount = 0
        
        return true
    }
    
    func succesfulRequest() {
        
        let offsetAtRequestStart = nextRequestOffset

        self.hasRequestInFlight = false
        self.cancelRetry()
        self.retryCount = 0

        self.hasReceivedAFailure = false

//        if (self.nextOffset != offsetAtRequestStart) {
//            // If another request has modified items since this
//            // request began, ignore this response.
//            return
//        }
//
//
//        self.hasReceivedAResponse = true
//
//        self.lastRequestResultCount = results.count
//
//        if (!self.totalResultCount) {
//            self.totalResultCount = totalResultCount
//        }
//        if (results.count == 0) {
//            self.hasReceivedEmptyResponse = true
//        }
//        self.nextOffset = offsetAtRequestStart + self.requestNumberOfImages
//        self.responseId = responseId

        self.fireRequestUpdate()
    
    
    }
    
    func failedRequest() {
        self.hasRequestInFlight = false
        self.hasReceivedAFailure = true
        self.scheduleRetry()
        self.fireRequestUpdate()
    }
    
    
    // MARK: Operation function
    
    /// Override the Operation function main to handle the request
    ///
    override public func main() {
        client.session.dataTask(with: config.getRequest()) { data, response, error in
            
            if self.isCancelled {
                return
            }
            
            #if !os(watchOS)
                if !self.client.isNetworkReachable() {
                    self.failedRequest()
                    self.callCompletion(data: nil, response: response, error: GPHHTTPError(statusCode:100, description: "Network is not reachable"))
                    self.state = .finished
                    return
                }
            #endif

            do {
                guard let data = data else {
                    self.failedRequest()
                    self.callCompletion(data: nil, response: response, error:GPHJSONMappingError(description: "Can not map API response to JSON, there is no data"))
                    self.state = .finished
                    return
                }
                
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let result = result as? GPHJSONObject {
                    // Got the JSON
                    let httpResponse = response! as! HTTPURLResponse
                    // Get the status code from the JSON if available and prefer it over the response code from HTTPURLRespons
                    // If not found return the actual response code from http
                    let statusCode = ((result["meta"] as? GPHJSONObject)?["status"] as? Int) ?? httpResponse.statusCode
                    
                    if httpResponse.statusCode != 200 || statusCode != 200 {
                        // Get the error message from JSON if available.
                        let errorMessage = (result["meta"] as? GPHJSONObject)?["msg"] as? String
                        // Prep the error
                        let errorAPIorHTTP = GPHHTTPError(statusCode: statusCode, description: errorMessage)
                        self.failedRequest()
                        self.callCompletion(data: result, response: response, error: errorAPIorHTTP)
                        self.state = .finished
                        return
                    }
                    
                    self.callCompletion(data: result, response: response, error: error)
                    self.state = .finished
                    
                } else {
                    self.failedRequest()
                    self.callCompletion(data: nil, response: response, error: GPHJSONMappingError(description: "Can not map API response to JSON"))
                    self.state = .finished
                }
            } catch {
                self.failedRequest()
                self.callCompletion(data: nil, response: response, error: error)
                self.state = .finished
            }
            
        }.resume()
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


/// Request Type for URLRequest objects.
///
public enum GPHRequestType: String {
    
    /// POST request
    case post = "POST"
    
    /// GET Request
    case get = "GET"
    
    /// PUT Request
    case put = "PUT"
    
    /// DELETE Request
    case delete = "DELETE"

    /// UPLOAD Request
    case upload = "UPLOAD"
}

/// Router to generate URLRequest objects.
///
public enum GPHRequestRouter {
    /// MARK: Properties
    
    /// Setup the Request: Path, Method, Parameters, Headers)
    case request(String, GPHRequestType, [URLQueryItem]?, [String: String]?)
    
    /// Base endpoint url.
    static let baseURLString = "https://api.giphy.com/v1/"
    
    /// Base upload endpoint url.
    static let baseUploadURLString = "https://upload.giphy.com/v1/"
    
    /// HTTP Method type.
    var method: GPHRequestType {
        switch self {
        case .request(_, let method, _, _):
            return method
        }
    }
    
    /// Full URL
    var url: URL {
        switch self {
        case .request(let path, let method, _, _):
            let baseUrl = (method == .upload ? URL(string: GPHRequestRouter.baseUploadURLString)! :
                                               URL(string: GPHRequestRouter.baseURLString)!)
            return baseUrl.appendingPathComponent(path)
        }
    }
    
    /// Query Parameters
    var query: [URLQueryItem] {
        switch self {
        case .request(_, _, let queryItems, _):
            return queryItems ?? []
        }
    }
    
    /// Custom Headers
    var headers: [String: String] {
        switch self {
        case .request(_, _, _, let customHeaders):
            return customHeaders ?? [:]
        }
    }
    
    // MARK: Helper functions
    
    /// Encode a URLQueryItem for including in HTTP requests
    /// (encodes + signs correctly to %2B)
    ///
    /// - parameter queryItem: URLQueryItem to be encoded.
    /// - returns: a URLQueryItem whose value is correctly percent-escaped.
    ///
    public func encodedURLQueryItem(_ queryItem: URLQueryItem) -> URLQueryItem {
        var allowedCharacters: CharacterSet = CharacterSet.urlQueryAllowed
        
        // Removing the characters that AlamoFire removes to match behaviour:
        // https://github.com/Alamofire/Alamofire/blob/master/Source/ParameterEncoding.swift#L236
        
        allowedCharacters.remove(charactersIn: ":#[]@!$&'()*+,;=")
        let encodedValue = queryItem.value?.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        return URLQueryItem(name: queryItem.name, value: encodedValue)
    }
    

    /// Construct the request from url, method and parameters.
    ///
    /// - parameter apiKey: Api-key for the request.
    /// - returns: A URLRequest object constructed from the current type of the request.
    ///
    public func asURLRequest(_ apiKey: String) -> URLRequest {
        
        var queryItems = query
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        // Get the final url
        let finalUrl: URL = {
            switch method {
            case .get:
                var urlComponents = URLComponents(string: url.absoluteString)
                urlComponents?.queryItems = queryItems
                guard let fullUrl = urlComponents?.url else { return url }
                return fullUrl
            default:
                return url
            }
        }()
        
        // Create the request.
        var request = URLRequest(url: finalUrl)
        request.httpMethod = (method == .upload ? "POST" : method.rawValue)
        
        // Add the custom headers.
        for (header, value) in headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        switch method {
        case .post, .delete, .put:
            // Set up request parameters.
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            
            var urlComponents = URLComponents(string: url.absoluteString)
            let encodedQueryItems: [URLQueryItem] = queryItems.map { queryItem in
                return encodedURLQueryItem(queryItem)
            }
            urlComponents?.queryItems = encodedQueryItems
            request.httpBody = (urlComponents?.query ?? "").data(using: String.Encoding.utf8)
        case .get:
            request.addValue("application/json", forHTTPHeaderField: "content-type")
        default:
            break
        }
        
        return request
    }
}
