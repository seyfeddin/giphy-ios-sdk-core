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
    public private(set) var gifUrl: String?

    /// URL of the Still Gif file
    public private(set) var stillGifUrl: String?
    
    /// Width
    public private(set) var width: Int?
    
    /// Height
    public private(set) var height: Int?

    /// # of Frames
    public private(set) var frames: Int?
    
    /// Gif file size in bytes
    public private(set) var gifSize: Int?
    
    /// URL of the WebP file
    public private(set) var webPUrl: String?

    /// Gif file size in bytes
    public private(set) var webPSize: Int?
    
    /// URL of the mp4 file
    public private(set) var mp4Url: String?
    
    /// Gif file size in bytes
    public private(set) var mp4Size: Int?
    
    override public init() {
        self.id = ""
        self.rendition = .original
        super.init()
    }
    
    convenience init(_ id: String,
                     rendition: GPHRenditionType,
                     gifUrl: String?,
                     stillGifUrl: String?,
                     gifSize: Int?,
                     width: Int?,
                     height: Int?,
                     frames: Int?,
                     webPUrl: String?,
                     webPSize: Int?,
                     mp4Url: String?,
                     mp4Size: Int?) {
        self.init()
        self.id = id
        self.rendition = rendition
        self.gifUrl = gifUrl
        self.stillGifUrl = stillGifUrl
        self.gifSize = gifSize
        self.width = width
        self.height = height
        self.frames = frames
        self.webPUrl = webPUrl
        self.webPSize = webPSize
        self.mp4Url = mp4Url
        self.mp4Size = mp4Size
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id") as? String,
            let rendition = aDecoder.decodeObject(forKey: "rendition") as? GPHRenditionType
        else {
            return nil
        }
        
        let gifUrl = aDecoder.decodeObject(forKey: "gifUrl") as? String
        let stillGifUrl = aDecoder.decodeObject(forKey: "stillGifUrl") as? String
        let gifSize = aDecoder.decodeObject(forKey: "gifSize") as? Int
        let width = aDecoder.decodeObject(forKey: "width") as? Int
        let height = aDecoder.decodeObject(forKey: "height") as? Int
        let frames = aDecoder.decodeObject(forKey: "frames") as? Int
        let webPUrl = aDecoder.decodeObject(forKey: "webPUrl") as? String
        let webPSize = aDecoder.decodeObject(forKey: "webPSize") as? Int
        let mp4Url = aDecoder.decodeObject(forKey: "mp4Url") as? String
        let mp4Size = aDecoder.decodeObject(forKey: "mp4Size") as? Int
        
        self.init(id,
                  rendition: rendition,
                  gifUrl: gifUrl,
                  stillGifUrl: stillGifUrl,
                  gifSize: gifSize,
                  width: width,
                  height: height,
                  frames: frames,
                  webPUrl: webPUrl,
                  webPSize: webPSize,
                  mp4Url: mp4Url,
                  mp4Size: mp4Size)
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
    public static func mapData(_ id: String,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHImage?, error: GPHJSONMappingError?) {
        
        let gifUrl = jsonData["url"] as? String
        let stillGifUrl = jsonData["still_url"]  as? String
        let gifSize = parseInt(jsonData["size"] as? String)
        let width = parseInt(jsonData["width"] as? String)
        let height = parseInt(jsonData["height"] as? String)
        let frames = parseInt(jsonData["frames"] as? String)
        let webPUrl = jsonData["webp_url"] as? String
        let webPSize = parseInt(jsonData["webp_size"] as? String)
        let mp4Url = jsonData["mp4_url"] as? String
        let mp4Size = parseInt(jsonData["mp4_size"] as? String)
        
        let obj = GPHImage(id,
                           rendition: renditionType,
                           gifUrl: gifUrl,
                           stillGifUrl: stillGifUrl,
                           gifSize: gifSize,
                           width: width,
                           height: height,
                           frames: frames,
                           webPUrl: webPUrl,
                           webPSize: webPSize,
                           mp4Url: mp4Url,
                           mp4Size: mp4Size)

        //        return (nil, GPHJSONMappingError(description: "Couldn't map GPHImage for \(jsonData)"))
        return (obj, nil)
    }
    
}
