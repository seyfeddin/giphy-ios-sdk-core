//
//  GPHCategory.swift
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

/// Represents a Giphy Categories & Sub-categories
///
@objc public class GPHCategory: NSObject, NSCoding {
    
    /// Username
    public private(set) var name: String
    public private(set) var encodedName: String
    public private(set) var previewImage: GPHImage?
    public private(set) var subCategories: [GPHCategory]?
    

    override public init() {
        self.name = ""
        self.encodedName = ""
        super.init()
    }
    
    convenience init(_ name: String, encodedName: String, previewImage: GPHImage?, subCategories: [GPHCategory]?) {
        self.init()
        self.name = name
        self.encodedName = encodedName
        self.previewImage = previewImage
        self.subCategories = subCategories
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let encodedName = aDecoder.decodeObject(forKey: "encodedName") as? String
            else { return nil }
        
        let previewImage = aDecoder.decodeObject(forKey: "previewImage") as? GPHImage
        let subCategories = aDecoder.decodeObject(forKey: "subCategories") as? [GPHCategory]

        
        self.init(name, encodedName: encodedName, previewImage: previewImage, subCategories: subCategories)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.encodedName, forKey: "encodedName")
        aCoder.encode(self.previewImage, forKey: "previewImage")
        aCoder.encode(self.subCategories, forKey: "subCategories")
    }
    
    // MARK: NSCoder Hash and Equality/Identity
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHCategory === self {
            return true
        }
        if let other = object as? GPHCategory, self.name == other.name {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_category_\(self.name)".hashValue
    }
    
}

// MARK: Human readable

/// Make objects human readable
///
extension GPHCategory {
    
    override public var description: String {
        return "GPHCategory(\(self.name)) encoded: \(self.encodedName)"
    }
    
}

