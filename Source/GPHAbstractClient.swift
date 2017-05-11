//
//  GPHClientAbstract.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import Foundation

/// An abstract API client.
///
@objc public class GPHAbstractClient : NSObject {
    // MARK: Properties
    
    /// Giphy API key.
    @objc internal var _apiKey: String?

    /// Session
    var session: URLSession
    
    /// Default timeout for network requests. Default: 10 seconds.
    @objc public var timeout: TimeInterval = 10
    
    /// Time delay before a search request is fired or cancelled
    @objc public var searchDelay: TimeInterval = 0.200
    
    /// Number of characters before a search request is fired
    @objc public var searchDelayMinCharacters: Int = 2
    
    /// Operation queue used to keep track of network requests.
    let requestQueue: OperationQueue
    
    /// Maximum number of concurrent requests we allow per connection.
    private let maxConcurrentRequestsPerConnection = 4
    
    #if !os(watchOS)
    
    /// Network reachability detecter.
    var reachability: GPHNetworkReachability = GPHNetworkReachability()
    
    /// Whether to use network reachability to decide if online requests should be attempted.
    ///
    /// + Note: Not available on watchOS (the System Configuration framework is not available there).
    ///
    @objc public var useReachability: Bool = true
    
    #endif // !os(watchOS)
    
    // MARK: Initialization
    
    init(_ apiKey: String?) {
        self._apiKey = apiKey

        // WARNING:
        var clientHTTPHeaders: [String: String] = [:]
        clientHTTPHeaders["User-Agent"] = GPHAbstractClient.defaultUserAgent()
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = clientHTTPHeaders
        
        session = Foundation.URLSession(configuration: configuration)
        
        requestQueue = OperationQueue()
        requestQueue.name = "Giphy Api Requests"
        requestQueue.maxConcurrentOperationCount = configuration.httpMaximumConnectionsPerHost * maxConcurrentRequestsPerConnection
        
        super.init()
    }
    
    /// User-agent to be used per client
    private static func defaultUserAgent() -> String {
        return "Giphy SDK v1.0 (iOS)"
    }
    
    /// Encode Strings for appending to URLS for endpoints like Term Suggestions
    func encodedStringForUrl(_ string: String) -> String {
        guard
            let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else { return string }
        return encoded
    }

    /// Perform a request.
    ///
    /// - parameter request: URLRequest
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func httpRequest(with request: URLRequest, type: GPHRequestType, completionHandler: @escaping GPHJSONCompletionHandler) -> Operation {
        
        let operation = GPHRequest(self, request: request, type: type, completionHandler: completionHandler)
        self.requestQueue.addOperation(operation)
        
        return operation
    }
    
    
    /// Perform a request to get a single result
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func getRequest(with request: URLRequest, type: GPHRequestType, media: GPHMediaType, completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
        
         return self.httpRequest(with: request, type: type) { (data, response, error) in
             // Do the parsing and return:
             if let data = data {
                 let resultObj = GPHMediaResponse.mapData(nil, data: data, request: type, media: media)
                 
                 if resultObj.object == nil {
                     if let jsonError = resultObj.error {
                        completionHandler(nil, jsonError)
                     } else {
                        completionHandler(nil, GPHJSONMappingError(description: "Unexpected error"))
                     }
                     return
                 }
                 completionHandler(resultObj.object, error)
                return
             }
             completionHandler(nil, error)
         }
    }
    
    
    /// Perform a request to get a list of results
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func listRequest(with request: URLRequest, type: GPHRequestType, media: GPHMediaType, completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {

        return self.httpRequest(with: request, type: type) { (data, response, error) in
            // Do the parsing and return:
            if let data = data {
                let resultObj = GPHListMediaResponse.mapData(nil, data: data, request: type, media: media)
                
                if resultObj.object == nil {
                    if let jsonError = resultObj.error {
                        completionHandler(nil, jsonError)
                    } else {
                        completionHandler(nil, GPHJSONMappingError(description: "Unexpected error"))
                    }
                    return
                }
                completionHandler(resultObj.object, error)
                return
            }
            completionHandler(nil, error)
        }
    }
    
    /// Perform a request to get a list of term suggestions
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func listTermSuggestionsRequest(with request: URLRequest, type: GPHRequestType, media: GPHMediaType, completionHandler: @escaping GPHCompletionHandler<GPHListTermSuggestionRespose>) -> Operation {
        
        return self.httpRequest(with: request, type: type) { (data, response, error) in
            // Do the parsing and return:
            if let data = data {
                let resultObj = GPHListTermSuggestionRespose.mapData(nil, data: data, request: type, media: media)
                
                if resultObj.object == nil {
                    if let jsonError = resultObj.error {
                        completionHandler(nil, jsonError)
                    } else {
                        completionHandler(nil, GPHJSONMappingError(description: "Unexpected error"))
                    }
                    return
                }
                completionHandler(resultObj.object, error)
                return
            }
            completionHandler(nil, error)
        }
    }

    /// Perform a request to get a list of term suggestions
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func listCategoriesRequest(_ root:GPHCategory? = nil, with request: URLRequest, type: GPHRequestType, media: GPHMediaType, completionHandler: @escaping GPHCompletionHandler<GPHListCategoryResponse>) -> Operation {
        
        return self.httpRequest(with: request, type: type) { (data, response, error) in
            // Do the parsing and return:
            if let data = data {
                let resultObj = GPHListCategoryResponse.mapData(root, data: data, request: type, media: media)
                
                if resultObj.object == nil {
                    if let jsonError = resultObj.error {
                        completionHandler(nil, jsonError)
                    } else {
                        completionHandler(nil, GPHJSONMappingError(description: "Unexpected error"))
                    }
                    return
                }
                completionHandler(resultObj.object, error)
                return
            }
            completionHandler(nil, error)
        }
    }
    
    #if !os(watchOS)
    
    /// Decide whether a network request should be attempted in the current conditions.
    ///
    /// - returns: `true` if a network request should be attempted, `false` if the client should fail fast with a
    ///            network error.
    ///
    func shouldMakeNetworkCall() -> Bool {
        return !useReachability || reachability.isReachable()
    }
    
    #endif // !os(watchOS)
}
