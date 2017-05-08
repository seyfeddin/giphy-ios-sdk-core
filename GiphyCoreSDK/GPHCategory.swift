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
    public fileprivate(set) var name: String
    public fileprivate(set) var nameEncoded: String
    public fileprivate(set) var encodedPath: String
    public fileprivate(set) var gif: GPHObject?
    public fileprivate(set) var subCategories: [GPHCategory]?
    

    override public init() {
        self.name = ""
        self.nameEncoded = ""
        self.encodedPath = ""
        super.init()
    }
    
    convenience init(_ name: String, nameEncoded: String, encodedPath: String) {
        self.init()
        self.name = name
        self.nameEncoded = nameEncoded
        self.encodedPath = encodedPath
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name") as? String,
            let nameEncoded = aDecoder.decodeObject(forKey: "nameEncoded") as? String,
            let encodedPath = aDecoder.decodeObject(forKey: "encodedPath") as? String
        else {
            return nil
        }
        
        self.init(name, nameEncoded: nameEncoded, encodedPath: encodedPath)
        
        self.gif = aDecoder.decodeObject(forKey: "previewImage") as? GPHObject
        self.subCategories = aDecoder.decodeObject(forKey: "subCategories") as? [GPHCategory]

    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.nameEncoded, forKey: "nameEncoded")
        aCoder.encode(self.gif, forKey: "gif")
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
        return "GPHCategory(\(self.name)) encoded: \(self.nameEncoded) and path:\(self.encodedPath)"
    }
    
}

// MARK: Parsing & Mapping

/// For parsing/mapping protocol
///
extension GPHCategory: GPHMappable {
    
    /// this is where the magic will happen + error handling
    public static func mapData(_ root: GPHCategory?,
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
        
        var gif:GPHObject? = nil
        
        if let gifData = jsonData["gif"] as? GPHJSONObject {
            gif = GPHObject.mapData(nil, data: gifData, request: requestType, media: mediaType).object
        }
        
        obj.gif = gif
        
        switch requestType {
        case .categories:
            
            obj.encodedPath = nameEncoded
            
            if let subCategoriesJSON = jsonData["subcategories"] as? [GPHJSONObject] {
                if subCategoriesJSON.count > 0 {
                    obj.subCategories = []
                    for subcategoryJSON in subCategoriesJSON {
                        // Create all the sub categories
                        let subObjResult = GPHCategory.mapData(obj, data: subcategoryJSON, request: .subCategories)
                        if let subObj = subObjResult.object {
                            obj.subCategories?.append(subObj)
                        } else {
                            return (nil, GPHJSONMappingError(description: "Couldn't map SubCategory GPHCategory for \(subcategoryJSON)"))
                        }
                    }
                }
            }
            
        case .subCategories:
            if let root = root {
                obj.encodedPath = root.nameEncoded + "/" + nameEncoded
            } else {
                return (nil, GPHJSONMappingError(description: "You need to root category to get sub-categories"))
            }
            obj.subCategories = nil
        default:
           return (nil, GPHJSONMappingError(description: "Request type is not valid for Categories"))
        }
        
        return (obj, nil)
    }
    
}


