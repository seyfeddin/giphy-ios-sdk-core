//
//  GPHChannel.swift
//  GiphyCoreSDK
//
//  Created by David Hargat on 09/10/17.
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

/// Represents Giphy Channels
///
/// Open Question:
///     The channels under `children` have less data -
///     should we make a GPHChannelChild object to make this clearer?
///
@objc public class GPHChannel: NSObject, NSCoding {
    // MARK: Properties
    
    // Stickers Packs Channel Root ID
    public static let StickersRootId = 3143
    
    /// ID of this Channel TODO: not sure if we want this.
    public fileprivate(set) var id: Int = -1
    
    /// Slug of the Channel.
    public fileprivate(set) var slug: String?
    
    /// Display name of the Channel.
    public fileprivate(set) var displayName: String?
    
    /// Shortd display name of the Channel.
    public fileprivate(set) var shortDisplayName: String?

    /// TODO: Make this an enum
    public fileprivate(set) var type: String?
    
    /// Content Type (Gif or Sticker) of the Channel
    public fileprivate(set) var contentType: String?
    
    /// Description of the Channel.
    public fileprivate(set) var descriptionText: String?
    
    /// Banner Image of the Channel.
    public fileprivate(set) var bannerImage: String?
    
    /// [optional] The featured gif for the pack itself.
    public fileprivate(set) var featuredGif: GPHMedia?
    
    /// User who owns this Channel.
    public fileprivate(set) var user: GPHUser?
    
    /// TODO: GPHChannelTag?
    public fileprivate(set) var tags: Array<String> = []
    
    /// A list of direct ancestors of this Channel.
    public fileprivate(set) var ancestors: Array<GPHChannel> = []
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// Convenience Initializer
    ///
    /// - parameter id: ID of the Channel.
    ///
    convenience public init(_ id: Int) {
        self.init()
        self.id = id
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id") as? Int
            else {
                return nil
        }
        
        self.init(id)
        
        self.slug = aDecoder.decodeObject(forKey: "slug") as? String
        self.type = aDecoder.decodeObject(forKey: "type") as? String
        self.contentType = aDecoder.decodeObject(forKey: "content_type") as? String
        self.bannerImage = aDecoder.decodeObject(forKey: "banner_image") as? String
        self.displayName = aDecoder.decodeObject(forKey: "display_name") as? String
        self.shortDisplayName = aDecoder.decodeObject(forKey: "short_display_name") as? String
        self.descriptionText = aDecoder.decodeObject(forKey: "description") as? String
        self.user = aDecoder.decodeObject(forKey: "user") as? GPHUser
        self.featuredGif = aDecoder.decodeObject(forKey: "featuredGif") as? GPHMedia ?? nil
        self.tags = aDecoder.decodeObject(forKey: "tags") as? Array<String> ?? []
        self.ancestors = aDecoder.decodeObject(forKey: "ancestors") as? Array<GPHChannel> ?? []
        
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.slug, forKey: "slug")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.bannerImage, forKey: "banner_image")
        aCoder.encode(self.contentType, forKey: "content_type")
        aCoder.encode(self.displayName, forKey: "display_name")
        aCoder.encode(self.descriptionText, forKey: "description")
        aCoder.encode(self.shortDisplayName, forKey: "short_display_name")
        
        aCoder.encode(self.user, forKey: "user")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.ancestors, forKey: "ancestors")
        aCoder.encode(self.featuredGif, forKey: "featured_gif")
        
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
    }
}

/// Make objects human readable.
///
extension GPHChannel {
    
    override public var description: String {
        return "GPHChannel(\(self.displayName)) id: \(self.id)"
    }
    
}

extension GPHChannel: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    static func mapData(_ root: GPHChannel?,
                        data jsonData: GPHJSONObject,
                        request requestType: GPHRequestType,
                        media mediaType: GPHMediaType = .gif,
                        rendition renditionType: GPHRenditionType = .original) throws -> GPHChannel {
        guard
            let objId: Int = jsonData["id"] as? Int
            else {
                throw GPHJSONMappingError(description: "Couldn't map GPHChannel due to missing 'id' field \(jsonData)")
        }
        
        let obj = GPHChannel()
        
        // These fields are OPTIONAL in the sense that we won't `throw` if they're missing
        // (though we might want to reconsider some of them).
        obj.id = objId
        obj.slug = (jsonData["slug"] as? String)
        obj.displayName = (jsonData["display_name"] as? String)
        obj.shortDisplayName = (jsonData["short_display_name"] as? String)
        obj.type = (jsonData["type"] as? String)
        obj.contentType = (jsonData["content_type"] as? String)
        obj.descriptionText = (jsonData["description"] as? String)
        obj.bannerImage = (jsonData["banner_image"] as? String)
        obj.featuredGif = (jsonData["featured_gif"] as? GPHMedia)
        
        obj.jsonRepresentation = jsonData
        
        // Handle User Data
        if let userData = jsonData["user"] as? GPHJSONObject {
            obj.user = try GPHUser.mapData(nil, data: userData, request: requestType, media: mediaType)
        }
        
        if let ancestors = jsonData["ancestors"] as? Array<GPHJSONObject> {
            for ancestor in ancestors {
                let ancestor = try GPHChannel.mapData(nil, data: ancestor, request: requestType)
                obj.ancestors.append(ancestor)
            }
        }
        
        return obj
    }
    
}
