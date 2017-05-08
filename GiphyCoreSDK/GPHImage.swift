//
//  GPHImage.swift
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

/// Represents a Giphy Image (Gif/Sticker)
///
@objc public class GPHImage: NSObject, NSCoding {
    
    /// ID of the Represented Object
    public fileprivate(set) var id: String

    /// ID of the Represented Object
    public fileprivate(set) var rendition: GPHRenditionType
    
    /// URL of the Gif file
    public fileprivate(set) var gifUrl: String?

    /// URL of the Still Gif file
    public fileprivate(set) var stillGifUrl: String?
    
    /// Width
    public fileprivate(set) var width: Int?
    
    /// Height
    public fileprivate(set) var height: Int?

    /// # of Frames
    public fileprivate(set) var frames: Int?
    
    /// Gif file size in bytes
    public fileprivate(set) var gifSize: Int?
    
    /// URL of the WebP file
    public fileprivate(set) var webPUrl: String?

    /// Gif file size in bytes
    public fileprivate(set) var webPSize: Int?
    
    /// URL of the mp4 file
    public fileprivate(set) var mp4Url: String?
    
    /// Gif file size in bytes
    public fileprivate(set) var mp4Size: Int?
    
    override public init() {
        self.id = ""
        self.rendition = .original
        super.init()
    }
    
    convenience init(_ id: String,
                     rendition: GPHRenditionType) {
        self.init()
        self.id = id
        self.rendition = rendition
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id") as? String,
            let rendition = aDecoder.decodeObject(forKey: "rendition") as? GPHRenditionType
        else {
            return nil
        }
        
        self.init(id, rendition: rendition)
                  
        self.gifUrl = aDecoder.decodeObject(forKey: "gifUrl") as? String
        self.stillGifUrl = aDecoder.decodeObject(forKey: "stillGifUrl") as? String
        self.gifSize = aDecoder.decodeObject(forKey: "gifSize") as? Int
        self.width = aDecoder.decodeObject(forKey: "width") as? Int
        self.height = aDecoder.decodeObject(forKey: "height") as? Int
        self.frames = aDecoder.decodeObject(forKey: "frames") as? Int
        self.webPUrl = aDecoder.decodeObject(forKey: "webPUrl") as? String
        self.webPSize = aDecoder.decodeObject(forKey: "webPSize") as? Int
        self.mp4Url = aDecoder.decodeObject(forKey: "mp4Url") as? String
        self.mp4Size = aDecoder.decodeObject(forKey: "mp4Size") as? Int
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.rendition, forKey: "rendition")
        aCoder.encode(self.gifUrl, forKey: "gifUrl")
        aCoder.encode(self.gifUrl, forKey: "stillGifUrl")
        aCoder.encode(self.gifSize, forKey: "gifSize")
        aCoder.encode(self.width, forKey: "width")
        aCoder.encode(self.height, forKey: "height")
        aCoder.encode(self.frames, forKey: "frames")
        aCoder.encode(self.webPUrl, forKey: "webPUrl")
        aCoder.encode(self.webPSize, forKey: "webPSize")
        aCoder.encode(self.mp4Url, forKey: "mp4Url")
        aCoder.encode(self.mp4Size, forKey: "mp4Size")
    }
    
    // MARK: NSCoder Hash and Equality/Identity
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHImage === self {
            return true
        }
        if let other = object as? GPHImage, self.id == other.id, self.rendition.rawValue == other.rendition.rawValue {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_image_\(self.id)_\(self.rendition.rawValue)".hashValue
    }
    
}

// MARK: Human readable

/// Make objects human readable
///
extension GPHImage {
    
    override public var description: String {
        return "GPHImage(for: \(self.id)) rendition: \(self.rendition.rawValue)"
    }
    
}

// MARK: Parsing & Mapping

/// For parsing/mapping protocol
///
extension GPHImage: GPHMappable {
    
    /// this is where the magic will happen + error handling
    public static func mapData(_ root: GPHObject?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHImage?, error: GPHJSONMappingError?) {
        
        guard let id = root?.id else {
            return (nil, GPHJSONMappingError(description: "Root object can not be nil, expected a GPHImages"))
        }
        
        let obj = GPHImage(id, rendition: renditionType)
        
        obj.gifUrl = jsonData["url"] as? String
        obj.stillGifUrl = jsonData["still_url"]  as? String
        obj.gifSize = parseInt(jsonData["size"] as? String)
        obj.width = parseInt(jsonData["width"] as? String)
        obj.height = parseInt(jsonData["height"] as? String)
        obj.frames = parseInt(jsonData["frames"] as? String)
        obj.webPUrl = jsonData["webp_url"] as? String
        obj.webPSize = parseInt(jsonData["webp_size"] as? String)
        obj.mp4Url = jsonData["mp4_url"] as? String
        obj.mp4Size = parseInt(jsonData["mp4_size"] as? String)

        return (obj, nil)
    }
    
}
