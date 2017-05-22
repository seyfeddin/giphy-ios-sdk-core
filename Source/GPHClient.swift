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

/// A JSON object.
public typealias GPHJSONObject = [String: Any]

//MARK: Generic Request & Completion Handlers

/// JSON/Error signature of generic request method
///
/// - parameter data: The JSON response (in case of success) or `nil` (in case of error).
/// - parameter response: The URLResponse object
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHJSONCompletionHandler = (_ data: GPHJSONObject?, _ response: URLResponse?, _ error: Error?) -> Void

/// Generic Completion Handler which accepts a Response type
///
/// - parameter response: Generic Response (GPHResponse, GPHMediaResponse..)
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHCompletionHandler<T> = (_ response: T?, _ error: Error?) -> Void


/// Entry point into the Swift API.
///
@objc public class GPHClient : GPHAbstractClient {
    // MARK: Properties
    
    /// Giphy API key.
    @objc public var apiKey: String {
        get { return _apiKey! }
        set { _apiKey = newValue }
    }
    
    /// Initilizer
    ///
    /// - parameter apiKey: Apps api-key to access end-points.
    ///
    @objc public init(apiKey: String) {
        super.init(apiKey)
    }
    
    //MARK: Search Endpoint
    
    /// Perform a search.
    ///
    /// - parameter query: Search parameters.
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter offset: Offset of results (default: 0)
    /// - parameter limit: Total hits you request (default: 25)
    /// - parameter rating: Rating of the content / optional (default R)
    /// - parameter lang: Language of the content / optional (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func search(_ query: String,
                                   media: GPHMediaType = .gif,
                                   offset: Int = 0,
                                   limit: Int = 25,
                                   rating: GPHRatingType = .ratedR,
                                   lang: GPHLanguageType = .english,
                                   completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
    
        
        let request = GPHRequestRouter.search(query, media, offset, limit, rating, lang).asURLRequest(apiKey)

        return self.listRequest(with: request, type: .search, media: media, completionHandler: completionHandler)
    }
    
    
    //MARK: Trending Endpoint
    
    /// Trending
    ///
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func trending(_  media: GPHMediaType = .gif,
                                     offset: Int = 0,
                                     limit: Int = 25,
                                     rating: GPHRatingType = .ratedR,
                                     completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
    
        let request = GPHRequestRouter.trending(media, offset, limit, rating).asURLRequest(apiKey)
        
        return self.listRequest(with: request, type: .trending, media: media, completionHandler: completionHandler)
    }
    
    
    //MARK: Translate Endpoint
    
    /// Translate
    ///
    /// - parameter term: term or phrase to translate into a GIF|Sticker
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter lang: language of the content / optional (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func translate(_ term: String,
                                      media: GPHMediaType = .gif,
                                      rating: GPHRatingType = .ratedR,
                                      lang: GPHLanguageType = .english,
                                      completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
    
        let request = GPHRequestRouter.translate(term, media, rating, lang).asURLRequest(apiKey)
        
        return self.getRequest(with: request, type: .translate, media: media, completionHandler: completionHandler)
    }
    
    
    //MARK: Random Endpoint
    
    /// Random
    ///
    /// Example: http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cats
    /// - parameter query: Search parameters.
    /// - parameter media: Media type / optional (default: .gif)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func random(_ query: String,
                                   media: GPHMediaType = .gif,
                                   rating: GPHRatingType = .ratedR,
                                   completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
    
        let request = GPHRequestRouter.random(query, media, rating).asURLRequest(apiKey)
        
        return self.getRequest(with: request, type: .random, media: media, completionHandler: completionHandler)
    }
    
    
    //MARK: Gifs by ID(s)
    
    /// GIF by ID
    ///
    /// - parameter id: Gif ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifByID(_ id: String,
                                    completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
    
        let request = GPHRequestRouter.get(id).asURLRequest(apiKey)
        
        return self.getRequest(with: request, type: .get, media: .gif, completionHandler: completionHandler)
    }
    
    
    /// GIFs by IDs
    ///
    /// - parameter ids: Gif ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifsByIDs(_ ids: [String],
                                     completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
    
        let request = GPHRequestRouter.getAll(ids).asURLRequest(apiKey)
        
        return self.listRequest(with: request, type: .getAll, media: .gif, completionHandler: completionHandler)
    }
    
    //MARK: Categories Endpoint
    
    /// Top Categories for Gifs
    ///
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func categoriesForGifs(_  offset: Int = 0,
                                                        limit: Int = 25,
                                                        completionHandler: @escaping GPHCompletionHandler<GPHListCategoryResponse>) -> Operation {
        
        
        let request = GPHRequestRouter.categories(.gif, offset, limit).asURLRequest(apiKey)
        return self.listCategoriesRequest(with: request, type: .categories, media: .gif, completionHandler: completionHandler)

    }
    
    /// Sub-Categories for Gifs
    ///
    /// - parameter category: top category to get sub-categories from
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func subCategoriesForGifs(_ category: String,
                                                          offset: Int = 0,
                                                          limit: Int = 25,
                                                          completionHandler: @escaping GPHCompletionHandler<GPHListCategoryResponse>) -> Operation {
        
        let categoryObj = GPHCategory(category, nameEncoded: encodedStringForUrl(category), encodedPath:encodedStringForUrl(category))
        let request = GPHRequestRouter.subCategories(categoryObj.encodedPath, .gif, offset, limit).asURLRequest(apiKey)
        return self.listCategoriesRequest(categoryObj, with: request, type: .subCategories, media: .gif, completionHandler: completionHandler)

        
    }
    
    /// Category Content (only works with Sub-categories / top categories won't return content)
    ///
    /// - parameter category: top category
    /// - parameter subCategory: sub-category to get contents from
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: rating of the content / optional (default R)
    /// - parameter lang: language of the content / optional (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifsByCategory(_ category: String,
                                                    subCategory: String,
                                                    offset: Int = 0,
                                                    limit: Int = 25,
                                                    rating: GPHRatingType = .ratedR,
                                                    lang: GPHLanguageType = .english,
                                                    completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
        
        let encodedPath = "\(encodedStringForUrl(category))/\(encodedStringForUrl(subCategory))"
        let categoryObj = GPHCategory(category, nameEncoded: encodedStringForUrl(category), encodedPath:encodedPath)
        
        let request = GPHRequestRouter.categoryContent(categoryObj.encodedPath, .gif, offset, limit, rating, lang).asURLRequest(apiKey)
        return self.listRequest(with: request, type: .categoryContent, media: .gif, completionHandler: completionHandler)
    }
    
    //MARK: Term Suggestion Endpoint
    
    /// Term Suggestions
    ///
    /// - parameter term: Word/Words
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func termSuggestions(_ term: String,
                                                   completionHandler: @escaping GPHCompletionHandler<GPHListTermSuggestionResponse>) -> Operation {
        
        let request = GPHRequestRouter.termSuggestions(encodedStringForUrl(term)).asURLRequest(apiKey)
        
        return self.listTermSuggestionsRequest(with: request, type: .termSuggestions, media: .gif, completionHandler: completionHandler)
    }
    
}
