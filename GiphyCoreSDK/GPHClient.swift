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
    
    /// A JSON object.
    public typealias GPHJSONObject = [String: Any]
    
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
    public typealias GPHResultCompletionHandler = (_ data: GPHResult?, _ error: Error?) -> Void
    
    /// Multiple Results/Error signature of generic request method
    ///
    /// - parameter data: The GPHListResult response (in case of success) or `nil` (in case of error).
    /// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
    ///
    public typealias GPHListResultCompletionHandler = (_ data: GPHListResult?, _ error: Error?) -> Void

    /// Perform a request.
    ///
    /// - parameter query: Query parameters. GPHQuery
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func request(_ query: GPHQuery, completionHandler: @escaping GPHCompletionHandler) -> Operation {}
    
    
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
                                   completionHandler: @escaping GPHListResultCompletionHandler) -> Operation {}
    
    
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
                                     completionHandler: @escaping GPHListResultCompletionHandler) -> Operation {}
    
    
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
                                      completionHandler: @escaping GPHResultCompletionHandler) -> Operation {}
    
    
    /// Random
    ///
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
                                   completionHandler: @escaping GPHResultCompletionHandler) -> Operation {}
    
    
    /// GIF by ID
    ///
    /// - parameter id: Gif ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func gifByID(_ id: String,
                                    completionHandler: @escaping GPHResultCompletionHandler) -> Operation {}
    
    
    /// GIFs by IDs
    ///
    /// - parameter ids: Gif ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult func gifByIDs(_ ids: [String],
                                     completionHandler: @escaping GPHListResultCompletionHandler) -> Operation {}

}
