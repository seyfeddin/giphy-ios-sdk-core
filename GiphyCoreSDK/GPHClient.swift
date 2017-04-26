//
//  GPHClient.swift
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


/// Entry point into the Swift API.
///
@objc public class GPHClient : GPHAbstractClient {
    // MARK: Properties
    
    /// Giphy API key.
    @objc public var apiKey: String {
        get { return _apiKey! }
        set { _apiKey = newValue }
    }
    
    //MARK: Search Endpoint
    
    /// Perform a search.
    ///
    /// - parameter query: Search parameters.
    /// - parameter type: Media type / optional (default: .gif)
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter lang: language of the content / optional (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func search(_ query: String,
                                   type: GPHMediaType = .gif,
                                   offset: Int = 0,
                                   limit: Int = 25,
                                   rating: GPHRatingType = .ratedR,
                                   lang: GPHLanguageType = .english,
                                   completionHandler: @escaping GPHListResultCompletionHandler) -> Operation {
    
        
        let request = GPHRequestRouter.search(query, type, offset, limit, rating, lang).asURLRequest(apiKey)

        return self.httpRequest(with: request) { (data, response, error) in
            // Do the parsing and return:
            completionHandler(data, response, error)
        }
        
    }
    
    //MARK: Trending Endpoint
    
    /// Trending
    ///
    /// - parameter type: Media type / optional (default: .gif)
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func trending(_  type: GPHMediaType = .gif,
                                     offset: Int = 0,
                                     limit: Int = 25,
                                     rating: GPHRatingType = .ratedR,
                                     completionHandler: @escaping GPHCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.trending(type, offset, limit, rating).asURLRequest(apiKey)
        
        return self.httpRequest(with: request) { (data, response, error) in
            // Do the parsing and return:
            completionHandler(data, response, error)
        }
    
    }
    
    //MARK: Translate Endpoint
    
    /// Translate
    ///
    /// - parameter term: term or phrase to translate into a GIF|Sticker
    /// - parameter type: Media type / optional (default: .gif)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter lang: language of the content / optional (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func translate(_ term: String,
                                      type: GPHMediaType = .gif,
                                      rating: GPHRatingType = .ratedR,
                                      lang: GPHLanguageType = .english,
                                      completionHandler: @escaping GPHCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.translate(term, type, rating, lang).asURLRequest(apiKey)
        
        return self.httpRequest(with: request) { (data, response, error) in
            // Do the parsing and return:
            completionHandler(data, response, error)
        }
    
    }
    
    //MARK: Random Endpoint
    
    /// Random
    ///
    /// Example: http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cats
    /// - parameter query: Search parameters.
    /// - parameter type: Media type / optional (default: .gif)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func random(_ query: String,
                                   type: GPHMediaType = .gif,
                                   rating: GPHRatingType = .ratedR,
                                   completionHandler: @escaping GPHCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.random(query, type, rating).asURLRequest(apiKey)
        
        return self.httpRequest(with: request) { (data, response, error) in
            // Do the parsing and return:
            completionHandler(data, response, error)
        }
    
    }
    
    
    //MARK: Categories Endpoint
    
    //MARK: Term Suggestion Endpoint
    
    //MARK: Gifs by ID(s)
    
    /// GIF by ID
    ///
    /// - parameter id: Gif ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func gifByID(_ id: String,
                                    completionHandler: @escaping GPHCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.get(id).asURLRequest(apiKey)
        
        return self.httpRequest(with: request) { (data, response, error) in
            // Do the parsing and return:
            completionHandler(data, response, error)
        }
    
    }
    
    
    /// GIFs by IDs
    ///
    /// - parameter ids: Gif ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func gifByIDs(_ ids: [String],
                                     completionHandler: @escaping GPHCompletionHandler) -> Operation {
    
        let request = GPHRequestRouter.getAll(ids).asURLRequest(apiKey)
        
        return self.httpRequest(with: request) { (data, response, error) in
            // Do the parsing and return:
            completionHandler(data, response, error)
        }
    
    }

}
