//
//  GPHError.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/2/17.
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

/// Custom JSON Mapper Error
///
public struct GPHJSONMappingError: CustomNSError {
    // MARK: Properties

    /// Human readable issue.
    public let description: String
    
    /// Custom error code.
    public var errorCode: Int { return 1001 }
    
    
    // MARK: Initializers

    /// Initializer
    ///
    /// - parameter description: textual description of the error.
    ///
    public init(description: String) {
        self.description = description
    }
    
    
    // MARK: Helpers
    
    /// Creates a string with a detailed representation of the given value, suitable for debugging.
    public static var errorDomain: String = String(reflecting: GPHJSONMappingError.self)
    
    /// NSError style, return the dict for the error with description in place.
    public var errorUserInfo: GPHJSONObject {
        return [
            NSLocalizedDescriptionKey: description
        ]
    }
    
}

/// Custom HTTP Error
///
public struct GPHHTTPError: CustomNSError {
    // MARK: Properties
    
    /// Human readable issue, returned by the server.
    public let description: String?
    
    /// The HTTP status code returned by the server.
    public let statusCode: Int
    
    /// Custom error code.
    public var errorCode: Int { return statusCode }
    

    // MARK: Initializers
    
    /// Initializer
    ///
    /// - parameter statusCode: Status code from the server.
    /// - parameter description: Description returned from the server.
    ///
    public init(statusCode: Int, description: String? = nil) {
        self.statusCode = statusCode
        self.description = description
    }
    
    
    // MARK: Helpers
    
    /// Creates a string with a detailed representation of the given value, suitable for debugging.
    public static var errorDomain: String = String(reflecting: GPHJSONMappingError.self)
    
    /// NSError style, return the dict for the error with description in place.
    public var errorUserInfo: GPHJSONObject {
        var userInfo = GPHJSONObject()
        if let description = description {
            userInfo[NSLocalizedDescriptionKey] = description
        }
        return userInfo
    }

}
