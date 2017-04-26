//
//  GPHRequest.swift
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

/// A JSON object.
public typealias GPHJSONObject = [String: Any]

//MARK: Generic Request & Completion Handlers

/// JSON/Error signature of generic request method
///
/// - parameter data: The JSON response (in case of success) or `nil` (in case of error).
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHCompletionHandler = (_ data: GPHJSONObject?, _ response: URLResponse?, _ error: Error?) -> Void

/// Single Result/Error signature of generic request method
///
/// - parameter data: The GPHResult response (in case of success) or `nil` (in case of error).
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHResultCompletionHandler = (_ data: GPHJSONObject?, _ response: URLResponse?, _ error: Error?) -> Void

/// Multiple Results/Error signature of generic request method
///
/// - parameter data: The GPHListResult response (in case of success) or `nil` (in case of error).
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHListResultCompletionHandler = (_ data: GPHJSONObject?, _ response: URLResponse?, _ error: Error?) -> Void

class GPHRequest: GPHAsyncOperationWithCompletion {
    var request: URLRequest
    /// The client to which this request is related.
    let client: GPHAbstractClient
    
    init(_ client: GPHAbstractClient, request: URLRequest, completionHandler: @escaping GPHCompletionHandler) {
        self.client = client
        self.request = request
        super.init(completionHandler: completionHandler)
    }
    
    override func main() {
        client.session.dataTask(with: request) { data, response, error in
            
            if self.isCancelled {
                return
            }
            
            //guard let data = data, let response = response as? URLResponse else { return }
            
            var jsonResult: GPHJSONObject?
            
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                //print(result)
                
                if let myjsonResult = result as? GPHJSONObject {
                    jsonResult = myjsonResult
                    //print(myjsonResult)
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
            // Handle HTTP status code.
//            let httpResponse = response! as! HTTPURLResponse
//            if (finalError == nil && !StatusCode.isSuccess(httpResponse.statusCode)) {
//                // Get the error message from JSON if available.
//                let errorMessage = json?["message"] as? String
//                finalError = HTTPError(statusCode: httpResponse.statusCode, message: errorMessage)
//            }
            
            self.callCompletion(data: jsonResult, response: response, error: error)
            
            self.state = .finished
            }.resume()
    }
}

public enum GPHRequestRouter {
    
    // End-point requests that we will cover
    case search(String, GPHMediaType, Int, Int, GPHRatingType, GPHLanguageType) // query, type, offset, limit, rating, lang
    case trending(GPHMediaType, Int, Int, GPHRatingType) // type, offset, limit, rating
    case translate(String, GPHMediaType, GPHRatingType, GPHLanguageType) // term, type, rating, lang
    case random(String, GPHMediaType, GPHRatingType) // query, type, rating
    case get(String) // id
    case getAll([String]) // ids

    
    // Base endpoint
    static let baseURLString = "https://api.giphy.com/v1/"
    
    // Set the method
    var method: String {
        switch self {
        case .search, .trending, .translate, .random, .get, .getAll: return "GET"
        // in future when we have upload / auth / we will add PUT, DELETE, POST here
        }
    }
    
    // Construct the request from url, method and parameters
    public func asURLRequest(_ apiKey: String) -> URLRequest {
        // Build the request endpoint
        
        var queryItems:[URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        let url: URL = {
            let relativePath: String?
            switch self {
            case .search(let query, let type, let offset, let limit, let rating, let lang):
                relativePath = "\(type.rawValue)s/search"
                queryItems.append(URLQueryItem(name: "q", value: query))
                queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
                queryItems.append(URLQueryItem(name: "lang", value: lang.rawValue))
            case .trending(let type, let offset, let limit, let rating):
                relativePath = "\(type.rawValue)s/trending"
                queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
                queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
            case .translate(let term, let type, let rating, let lang):
                relativePath = "\(type.rawValue)s/translate"
                queryItems.append(URLQueryItem(name: "s", value: term))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
                queryItems.append(URLQueryItem(name: "lang", value: lang.rawValue))
            case .random(let query, let type, let rating):
                relativePath = "\(type.rawValue)s/random"
                queryItems.append(URLQueryItem(name: "tag", value: query))
                queryItems.append(URLQueryItem(name: "rating", value: rating.rawValue))
            case .get(let id):
                relativePath = "gifs/\(id)"
            case .getAll(let ids):
                queryItems.append(URLQueryItem(name: "ids", value: ids.flatMap({$0}).joined(separator:",")))
                relativePath = "gifs"
            }

            var url = URL(string: GPHRequestRouter.baseURLString)!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            
            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.queryItems = queryItems
            guard let fullUrl = urlComponents?.url else { return url }
            
            return fullUrl
        }()
        
        // Set up request parameters
        let parameters: [String: Any]? = {
            switch self {
            case .search, .trending, .translate, .random, .get, .getAll: return nil
            // in future when we have upload / auth / we will add PUT, DELETE, POST here
            }
        }()
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        if let parameters = parameters,
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            request.httpBody = data
        }
        return request
    }
}
