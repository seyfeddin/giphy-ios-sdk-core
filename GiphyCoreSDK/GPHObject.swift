//
//  GPHMedia.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 4/22/17.
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


/**
 Represents a Giphy Object
 */
@objc public class GPHObject: NSObject, NSCoding {
    
    public private(set) var type: GPHMediaType
    public private(set) var id: String!
    public private(set) var url: URL?
    public private(set) var rating: GPHRatingType
    public private(set) var caption: String?
    public private(set) var slug: String?
    public private(set) var importDate: String?
    public private(set) var trendingDate: String?
    public private(set) var indexable: String?
    public private(set) var content: String?
    public private(set) var bitly: URL?
    public private(set) var bitlyGif: URL?
    public private(set) var embed: URL?
    public private(set) var source: String?
    public private(set) var sourceTld: String?
    public private(set) var sourcePostUrl: URL?
    public private(set) var user: [String]?
    public private(set) var images: [String]?
    
    
//    convenience init(_ identifier: String, name: String, summary: String, previewImoji: IMImojiObject?) {
//        self.init()
//        self.identifier = identifier
//        self.name = name
//        self.summary = summary
//        self.previewImoji = previewImoji
//    }
//    
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard let identifier = aDecoder.decodeObject(forKey: "identifier") as? String,
//            let name = aDecoder.decodeObject(forKey: "name") as? String,
//            let summary = aDecoder.decodeObject(forKey: "summary") as? String
//            else { return nil }
//        
//        let previewImoji = aDecoder.decodeObject(forKey: "previewImoji") as? IMImojiObject
//        
//        self.init(identifier, name: name, summary: summary, previewImoji: previewImoji)
//        
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.identifier, forKey: "identifier")
//        aCoder.encode(self.name, forKey: "name")
//        aCoder.encode(self.summary, forKey: "summary")
//        aCoder.encode(self.previewImoji, forKey: "previewImoji")
//    }
    
    // MARK: NSCoder Hash and Equality/Identity
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHObject === self {
            return true
        }
        if let other = object as? GPHObject, self.id == other.id {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_object_\(self.id)".hashValue
    }
    
}
