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
public typealias GPHCompletionHandler = (_ data: GPHJSONObject?, _ error: Error?) -> Void

/// Single Result/Error signature of generic request method
///
/// - parameter data: The GPHResult response (in case of success) or `nil` (in case of error).
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHResultCompletionHandler = (_ data: GPHJSONObject?, _ error: Error?) -> Void

/// Multiple Results/Error signature of generic request method
///
/// - parameter data: The GPHListResult response (in case of success) or `nil` (in case of error).
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHListResultCompletionHandler = (_ data: GPHJSONObject?, _ error: Error?) -> Void

class GPHRequest: GPHAsyncOperation {
    var request: URLRequest
    /// The client to which this request is related.
    let client: GPHAbstractClient
    
    init(_ client: GPHAbstractClient, request: URLRequest) {
        self.client = client
        self.request = request
        super.init()
    }
    
    override func main() {
        client.session.dataTask(with: request) { data, response, error in
            
            guard let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 else { return }
            
            var jsonResult: [GPHJSONObject]
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: [])
                jsonResult = result as! [GPHJSONObject]
            } catch {
                print(error.localizedDescription)
                return
            }
            
            ///
            
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
    public func asURLRequest() -> URLRequest {
        // Build the request endpoint
        let url: URL = {
            let relativePath: String?
            switch self {
            case .search(_, let type, _, _, _, _): relativePath = "\(type.rawValue)s/search"
            case .trending(let type, _, _, _): relativePath = "\(type.rawValue)s/trending"
            case .translate(_, let type, _, _): relativePath = "\(type.rawValue)s/translate"
            case .random(_, let type, _): relativePath = "\(type.rawValue)s/random"
            case .get(let id): relativePath = "gifs/\(id)"
            case .getAll(let ids): relativePath = "gifs/\(ids.flatMap({$0}).joined(separator:","))"
            }
            
            var url = URL(string: GPHRequestRouter.baseURLString)!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            return url
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
