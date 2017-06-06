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

/// Represents Giphy Categories & Subcategories
///
@objc public class GPHCategory: NSObject, NSCoding {
    // MARK: Properties

    /// Name of the Category.
    public fileprivate(set) var name: String
    
    /// Encoded name of the Category.
    public fileprivate(set) var nameEncoded: String
    
    /// URL Encoded path of the Category (to make sure we have the full-path for subcategories).
    public fileprivate(set) var encodedPath: String
    
    /// GIF representation of the Category.
    public fileprivate(set) var gif: GPHMedia?
    
    /// Subcategories of the Category.
    public fileprivate(set) var subCategories: [GPHCategory]?
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    // MARK: Initializers
    
    /// Initializer
    ///
    override public init() {
        self.name = ""
        self.nameEncoded = ""
        self.encodedPath = ""
        super.init()
    }
    
    /// Convenience Initializer
    ///
    /// - parameter name: Name of the Category.
    /// - parameter nameEncoded: URL Encoded name of the Category.
    /// - parameter encodedPath: URL Encoded path of the Category (to make sure we have the full-path for subcategories).
    ///
    convenience public init(_ name: String, nameEncoded: String, encodedPath: String) {
        self.init()
        self.name = name
        self.nameEncoded = nameEncoded
        self.encodedPath = encodedPath
    }
    
    //MARK: NSCoding
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name") as? String,
            let nameEncoded = aDecoder.decodeObject(forKey: "nameEncoded") as? String,
            let encodedPath = aDecoder.decodeObject(forKey: "encodedPath") as? String
        else {
            return nil
        }
        
        self.init(name, nameEncoded: nameEncoded, encodedPath: encodedPath)
        
        self.gif = aDecoder.decodeObject(forKey: "gif") as? GPHMedia
        self.subCategories = aDecoder.decodeObject(forKey: "subCategories") as? [GPHCategory]
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.nameEncoded, forKey: "nameEncoded")
        aCoder.encode(self.encodedPath, forKey: "encodedPath")
        aCoder.encode(self.gif, forKey: "gif")
        aCoder.encode(self.subCategories, forKey: "subCategories")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
    }
    
    // MARK: NSObject

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

// MARK: Extension -- Helper Methods

/// Picking renditions and stuff.
///
extension GPHCategory {
    
    @objc
    public func addSubCategory(_ subCategory: GPHCategory) {
        if self.subCategories != nil {
            self.subCategories?.append(subCategory)
        } else {
            self.subCategories = [subCategory];
        }
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHCategory {
    
    override public var description: String {
        return "GPHCategory(\(self.name)) encoded: \(self.nameEncoded) and path:\(self.encodedPath)"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHCategory: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    static func mapData(_ root: GPHCategory?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHCategory?, error: GPHJSONMappingError?) {
        
        
        guard let name = jsonData["name"] as? String,
              let nameEncoded = jsonData["name_encoded"] as? String
        else {
            return (nil, GPHJSONMappingError(description: "Couldn't map GPHCategory for \(jsonData)"))
        }
        
        let obj = GPHCategory(name, nameEncoded: nameEncoded, encodedPath: "")
        
        var gif: GPHMedia? = nil
        
        if let gifData = jsonData["gif"] as? GPHJSONObject {
            gif = GPHMedia.mapData(nil, data: gifData, request: requestType, media: mediaType).object
        }
        
        obj.gif = gif
        
        switch requestType {
        case .categories:
            
            obj.encodedPath = nameEncoded
            
            if let subCategoriesJSON = jsonData["subcategories"] as? [GPHJSONObject] {
                if subCategoriesJSON.count > 0 {
                    obj.subCategories = []
                    for subCategoryJSON in subCategoriesJSON {
                        // Create all the sub categories
                        let subObjResult = GPHCategory.mapData(obj, data: subCategoryJSON, request: .subCategories)
                        if let subObj = subObjResult.object {
                            obj.subCategories?.append(subObj)
                        } else {
                            return (nil, GPHJSONMappingError(description: "Couldn't map subCategory GPHCategory for \(subCategoryJSON)"))
                        }
                    }
                }
            }
            
        case .subCategories:
            if let root = root {
                obj.encodedPath = root.nameEncoded + "/" + nameEncoded
            } else {
                return (nil, GPHJSONMappingError(description: "You need a root category to get sub-categories"))
            }
            obj.subCategories = nil
        default:
           return (nil, GPHJSONMappingError(description: "Request type is not valid for Categories"))
        }
        
        obj.jsonRepresentation = jsonData
        
        return (obj, nil)
    }
    
}


