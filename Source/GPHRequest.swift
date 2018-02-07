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


/// Async Request Operations with Completion Handler Support
///
class GPHRequest: GPHAsyncOperationWithCompletion {
    // MARK: Properties

    /// URLRequest obj to handle the networking.
    var request: URLRequest
    
    /// The client to which this request is related.
    let client: GPHAbstractClient
    
    let type: GPHRequestType
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter client: GPHClient object to handle the request.
    /// - parameter request: URLRequest to execute.
    /// - parameter type: Request type (GPHRequestType).
    /// - parameter completionHandler: GPHJSONCompletionHandler to return JSON or Error.
    ///
    init(_ client: GPHAbstractClient, request: URLRequest, type: GPHRequestType, completionHandler: @escaping GPHJSONCompletionHandler) {
        self.client = client
        self.request = request
        self.type = type
        super.init(completionHandler: completionHandler)
    }
    
    // MARK: Operation function
    
    /// Override the Operation function main to handle the request
    ///
    override func main() {
        client.session.dataTask(with: request) { data, response, error in
            
            if self.isCancelled {
                return
            }
            
            #if !os(watchOS)
                if !self.client.isNetworkReachable() {
                    self.callCompletion(data: nil, response: response, error: GPHHTTPError(statusCode:100, description: "Network is not reachable"))
                    return
                }
            #endif

            do {
                guard let data = data else {
                    self.callCompletion(data: nil, response: response, error:GPHJSONMappingError(description: "Can not map API response to JSON, there is no data"))
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
                        self.callCompletion(data: result, response: response, error: errorAPIorHTTP)
                        self.state = .finished
                        return
                    }
                    self.callCompletion(data: result, response: response, error: error)
                } else {
                    self.callCompletion(data: nil, response: response, error: GPHJSONMappingError(description: "Can not map API response to JSON"))
                }
            } catch {
                self.callCompletion(data: nil, response: response, error: error)
            }
            
            self.state = .finished
            
        }.resume()
    }
}


/// Router to generate URLRequest objects.
///
enum GPHRequestRouter {
    /// MARK: Properties
    
    /// Setup the Request: Path, Method, Parameters)
    case request(String, String, [URLQueryItem]?)
    
    /// Base endpoint url.
    static let baseURLString = "https://api.giphy.com/v1/"
    
    /// HTTP Method type.
    var method: String {
        switch self {
        case .request(_, let method, _):
            return method
        }
    }
    
    /// Full URL
    var url: URL {
        let baseUrl = URL(string: GPHRequestRouter.baseURLString)!
        switch self {
        case .request(let path, _, _):
            return baseUrl.appendingPathComponent(path)
        }
    }
    
    /// Query Parameters
    var query: [URLQueryItem] {
        let items:[URLQueryItem] = []
        switch self {
        case .request(_, _, let queryItems):
            return queryItems ?? items
        }
    }
    // MARK: Helper functions
    
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
            case "GET":
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
        request.httpMethod = method
            
        switch method {
        case "POST", "DELETE", "PUT":
            // Set up request parameters.
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            
            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.queryItems = queryItems
            request.httpBody = (urlComponents?.percentEncodedQuery ?? "").data(using: String.Encoding.utf8)
            
        default:
            request.addValue("application/json", forHTTPHeaderField: "content-type")
        }
        
        return request
    }
}


/// Represents a Giphy URLRequest Type
///
/// DIS IZ GOING AWAY!!! 

@objc public enum GPHRequestType: Int {
    
    /// Search Request.
    case search
    
    /// Trending Request.
    case trending
    
    /// Translate Request.
    case translate
    
    /// Random Item Request.
    case random
    
    /// Get an Item with ID.
    case get
    
    /// Get items with IDs.
    case getAll
    
    /// Get Term Suggestions.
    case termSuggestions
    
    /// Top Categories.
    case categories
    
    /// SubCategories of a Category.
    case subCategories
    
    /// Category Content.
    case categoryContent
    
    /// Get Channel by id.
    case channel
    
    /// Get Channel Children (sub Channels).
    case channelChildren
    
    /// Get Channel Gifs (media).
    case channelContent
    
}
