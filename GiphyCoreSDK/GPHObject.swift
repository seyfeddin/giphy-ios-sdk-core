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

/// Represents a Giphy Object
///
@objc public class GPHObject: NSObject, NSCoding {
    
    public fileprivate(set) var id: String
    public fileprivate(set) var type: GPHMediaType
    public fileprivate(set) var url: String
    public fileprivate(set) var rating: GPHRatingType?
    public fileprivate(set) var caption: String?
    public fileprivate(set) var slug: String?
    public fileprivate(set) var indexable: String?
    public fileprivate(set) var content: String?
    public fileprivate(set) var bitly: String?
    public fileprivate(set) var bitlyGif: String?
    public fileprivate(set) var embed: String?
    public fileprivate(set) var source: String?
    public fileprivate(set) var sourceTld: String?
    public fileprivate(set) var sourcePostUrl: String?
    public fileprivate(set) var user: GPHUser?
    public fileprivate(set) var images: GPHImages?
    public fileprivate(set) var tags: [String]?
    public fileprivate(set) var featuredTags: [String]?
    public fileprivate(set) var importDate: Date?
    public fileprivate(set) var createDate: Date?
    public fileprivate(set) var updateDate: Date?
    public fileprivate(set) var trendingDate: Date?
    
    // NOTE: Categories endpoint
    // Example: http://api.giphy.com/v1/gifs/categories/actions?api_key=4OMJYpPoYwVpe
    public fileprivate(set) var isHidden: Bool?
    public fileprivate(set) var isRemoved: Bool?
    public fileprivate(set) var isCommunity: Bool?
    public fileprivate(set) var isAnonymous: Bool?
    public fileprivate(set) var isFeatured: Bool?
    public fileprivate(set) var isRealtime: Bool?
    public fileprivate(set) var isIndexable: Bool?
    public fileprivate(set) var isSticker: Bool?


    
    override public init() {
        self.id = ""
        self.type = .gif
        self.url = ""
        super.init()
    }
    
    convenience init(_ id: String, type: GPHMediaType, url: String) {
        self.init()
        self.id = id
        self.type = type
        self.url = url
    }
    
    required public convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let type = aDecoder.decodeObject(forKey: "type") as? GPHMediaType,
            let url = aDecoder.decodeObject(forKey: "url") as? String
            else { return nil }
        
        self.init(id, type: type, url: url)
        
        self.rating = aDecoder.decodeObject(forKey: "rating") as? GPHRatingType
        self.caption = aDecoder.decodeObject(forKey: "caption") as? String
        self.slug = aDecoder.decodeObject(forKey: "slug") as? String
        self.importDate = aDecoder.decodeObject(forKey: "importDate") as? Date
        self.trendingDate = aDecoder.decodeObject(forKey: "trendingDate") as? Date
        self.indexable = aDecoder.decodeObject(forKey: "indexable") as? String
        self.content = aDecoder.decodeObject(forKey: "content") as? String
        self.bitly = aDecoder.decodeObject(forKey: "bitly") as? String
        self.bitlyGif = aDecoder.decodeObject(forKey: "bitlyGif") as? String
        self.embed = aDecoder.decodeObject(forKey: "embed") as? String
        self.source = aDecoder.decodeObject(forKey: "source") as? String
        self.sourceTld = aDecoder.decodeObject(forKey: "sourceTld") as? String
        self.sourcePostUrl = aDecoder.decodeObject(forKey: "sourcePostUrl") as? String
        self.user = aDecoder.decodeObject(forKey: "user") as? GPHUser
        self.images = aDecoder.decodeObject(forKey: "images") as? GPHImages
        self.tags = aDecoder.decodeObject(forKey: "tags") as? [String]
        self.featuredTags = aDecoder.decodeObject(forKey: "featuredTags") as? [String]
        
        // NOTE: Categories endpoint
        self.isHidden = aDecoder.decodeObject(forKey: "isHidden") as? Bool
        self.isRemoved = aDecoder.decodeObject(forKey: "isRemoved") as? Bool
        self.isCommunity = aDecoder.decodeObject(forKey: "isCommunity") as? Bool
        self.isAnonymous = aDecoder.decodeObject(forKey: "isAnonymous") as? Bool
        self.isFeatured = aDecoder.decodeObject(forKey: "isFeatured") as? Bool
        self.isRealtime = aDecoder.decodeObject(forKey: "isRealtime") as? Bool
        self.isIndexable = aDecoder.decodeObject(forKey: "isIndexable") as? Bool
        self.isSticker = aDecoder.decodeObject(forKey: "isSticker") as? Bool
        self.updateDate = aDecoder.decodeObject(forKey: "updateDate") as? Date
        self.createDate = aDecoder.decodeObject(forKey: "createDate") as? Date
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.rating, forKey: "rating")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.importDate, forKey: "importDate")
        aCoder.encode(self.trendingDate, forKey: "trendingDate")
        aCoder.encode(self.indexable, forKey: "indexable")
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.bitly, forKey: "bitly")
        aCoder.encode(self.bitlyGif, forKey: "bitlyGif")
        aCoder.encode(self.embed, forKey: "embed")
        aCoder.encode(self.source, forKey: "source")
        aCoder.encode(self.sourceTld, forKey: "sourceTld")
        aCoder.encode(self.sourcePostUrl, forKey: "sourcePostUrl")
        aCoder.encode(self.user, forKey: "user")
        aCoder.encode(self.images, forKey: "images")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.featuredTags, forKey: "featuredTags")

        // NOTE: Categories endpoint
        aCoder.encode(self.isHidden, forKey: "isHidden")
        aCoder.encode(self.isRemoved, forKey: "isRemoved")
        aCoder.encode(self.isCommunity, forKey: "isCommunity")
        aCoder.encode(self.isAnonymous, forKey: "isAnonymous")
        aCoder.encode(self.isFeatured, forKey: "isFeatured")
        aCoder.encode(self.isRealtime, forKey: "isRealtime")
        aCoder.encode(self.isIndexable, forKey: "isIndexable")
        aCoder.encode(self.isSticker, forKey: "isSticker")
        aCoder.encode(self.updateDate, forKey: "updateDate")
        aCoder.encode(self.createDate, forKey: "createDate")
        
    }
    
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

// MARK: Human readable

/// Make objects human readable
///
extension GPHObject {
    
    override public var description: String {
        return "GPHObject(\(self.type.rawValue)) for \(self.id) --> \(self.url)"
    }
    
}

// MARK: Parsing & Mapping

/// For parsing/mapping protocol
///
extension GPHObject: GPHMappable {

    /// this is where the magic will happen + error handling
    public static func mapData(_ root: GPHObject?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHObject?, error: GPHJSONMappingError?) {
        guard
            let objId: String = jsonData["id"] as? String,
            let url: String = jsonData["url"] as? String
        else {
            return (nil, GPHJSONMappingError(description: "Couldn't map GPHObject for \(jsonData)"))
        }
        
        let obj = GPHObject(objId, type: mediaType, url: url)
        
        obj.rating = parseRating(jsonData["rating"] as? String)
        obj.caption = jsonData["caption"] as? String
        obj.slug = jsonData["slug"] as? String
        obj.importDate = parseDate(jsonData["import_datetime"] as? String)
        obj.trendingDate = parseDate(jsonData["trending_datetime"] as? String)
        obj.indexable = jsonData["indexable"] as? String
        obj.content = jsonData["content"] as? String
        obj.bitly = jsonData["bitly"] as? String
        obj.bitlyGif = jsonData["bitly_gif"] as? String
        obj.embed = jsonData["embed"] as? String
        obj.source = jsonData["source"] as? String
        obj.sourceTld = jsonData["source_tld"] as? String
        obj.sourcePostUrl = jsonData["source_post_url"] as? String
        obj.tags = jsonData["tags"] as? [String]
        obj.featuredTags = jsonData["featured_tags"] as? [String]
        obj.isHidden = jsonData["is_hidden"] as? Bool
        obj.isRemoved = jsonData["is_removed"] as? Bool
        obj.isCommunity = jsonData["is_community"] as? Bool
        obj.isAnonymous = jsonData["is_anonymous"] as? Bool
        obj.isFeatured = jsonData["is_featured"] as? Bool
        obj.isRealtime = jsonData["is_realtime"] as? Bool
        obj.isIndexable = jsonData["is_indexable"] as? Bool
        obj.isSticker = jsonData["is_sticker"] as? Bool
        obj.updateDate = parseDate(jsonData["update_datetime"] as? String)
        obj.createDate = parseDate(jsonData["create_datetime"] as? String)
        
        // Handle User Data
        if let userData = jsonData["user"] as? GPHJSONObject {
            obj.user = GPHUser.mapData(obj, data: userData, request: requestType, media: mediaType).object
        }
        
        // Handling exception of the Random endpoint structure
        switch requestType {
        case .random:
            let renditionResults = GPHImages.mapData(obj, data: jsonData, request: requestType, media: mediaType)
            if let renditions = renditionResults.object {
                obj.images = renditions
            } else {
                // fail? or return nil -- this is conditional depending on the end-point
                return (nil, renditionResults.error)
            }
        default:
            if let renditionData = jsonData["images"] as? GPHJSONObject {
                let renditionResults = GPHImages.mapData(obj, data: renditionData, request: requestType, media: mediaType)
                if let renditions = renditionResults.object {
                    obj.images = renditions
                } else {
                    // fail? or return nil -- this is conditional depending on the end-point
                    return (nil, renditionResults.error)
                }
            }
        }
        
        return (obj, nil)
    }

}
