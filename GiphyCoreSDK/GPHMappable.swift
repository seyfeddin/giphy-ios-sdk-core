//
//  GPHMappable.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/3/17.
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

/// Make sure Models implement this protocol to be able to map JSON>Obj
protocol GPHMappable {
    
    associatedtype GPHMappableObject
    /// mapData
    /// Static function to map JSON to objects
    ///
    /// - parameter id: id of the object to be used for hashing
    /// - parameter data: GPHJSONObect data to be mapped
    /// - parameter request: request type to manipulate the data (if .search vs .translate, mapping will be different)
    /// - parameter media: media type, GIF|Sticker|... (optional)
    /// - parameter rendition: rendition type (optional)
    /// - returns: (object: Self?, error: GPHJSONMappingError?) pretty much either an instance of itself mapped OR an error (mutually exclusive)
    ///
    static func mapData(_ id: String,
                        data jsonData: GPHJSONObject,
                        request requestType: GPHRequestType,
                        media mediaType: GPHMediaType,
                        rendition renditionType: GPHRenditionType) -> (object: GPHMappableObject?, error: GPHJSONMappingError?)
    
}

/// Extend protocol to have default behavior
/// We will use this to map JSON to particular types of objs we want like Date, URL, ...
extension GPHMappable {
    
    /// parseDate
    ///
    /// - parameter date: String version of the Date to be mapped to Date type
    /// - returns: a Date object or nil
    ///
    static func parseDate(_ date: String?) -> Date? {
        if let date = date {
            //"2013-03-21 04:03:08"
            // "2016-07-13 21:50:57",
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let dateObj = dateFormatter.date(from:date) {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour], from: dateObj)
                return calendar.date(from:components)
            }
            return nil
        }
        return nil
    }

    /// parseURL
    ///
    /// - parameter date: String version of the Date to be mapped to Date type
    /// - returns: a Date object or nil
    ///
    static func parseURL(_ url: String?) -> URL? {
        if let url = url {
            return URL(string: url)
        }
        return nil
    }
    
    
    /// parseRating
    ///
    /// - parameter date: String version of the Date to be mapped to Date type
    /// - returns: a GPHRatingType object or nil
    ///
    static func parseRating(_ rating: String?) -> GPHRatingType? {
        if let rating = rating {
            return GPHRatingType(rawValue: rating)
        }
        return nil
    }
    

}
