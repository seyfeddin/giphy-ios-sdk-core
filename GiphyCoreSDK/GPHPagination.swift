//
//  GPHPagination.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/7/17.
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

/// Represents a Giphy Response Pagination Info
///
@objc public class GPHPagination: NSObject {
    
    /// Username
    public private(set) var totalCount: Int
    public private(set) var count: Int
    public private(set) var offset: Int
    
    override public init() {
        self.totalCount = 0
        self.count = 0
        self.offset = 0
        super.init()
    }
    
    convenience init(_ totalCount: Int, count: Int, offset: Int) {
        self.init()
        self.totalCount = totalCount
        self.count = count
        self.offset = offset
    }
    
}

// MARK: Human readable

/// Make objects human readable
///
extension GPHPagination {
    
    override public var description: String {
        return "GPHPagination(totalCount: \(self.totalCount) count: \(self.count) offset: \(self.offset))"
    }
    
}

// MARK: Parsing & Mapping

/// For parsing/mapping protocol
///
extension GPHPagination: GPHMappable {
    
    /// this is where the magic will happen + error handling
    public static func mapData(_ root: GPHPagination?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHPagination?, error: GPHJSONMappingError?) {
        
        guard
            let count = jsonData["count"] as? Int
        else {
            return (nil, GPHJSONMappingError(description: "Couldn't map GPHPagination for \(jsonData)"))
        }
        
        let totalCount = jsonData["total_count"] as? Int ?? count
        let offset = jsonData["offset"] as? Int ?? 0
        
        let obj = GPHPagination(totalCount, count: count, offset: offset)
        
        return (obj, nil)
    }
    
}
