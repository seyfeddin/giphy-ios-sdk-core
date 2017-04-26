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
    
    /// Image ID
    public private(set) var id: String!
    
    /// Display Name for the User
    public private(set) var type: GPHMediaType!

    /// Rendition
    public private(set) var rendition: GPHRenditionType!
    
    /// URL of the Gif file
    public private(set) var gifUrl: URL!
    
    /// Width
    public private(set) var width: Int?
    
    /// Height
    public private(set) var height: Int?
    
    /// Gif file size in bytes
    public private(set) var gifSize: Int?
    
    /// URL of the WebP file
    public private(set) var webPUrl: URL?

    /// Gif file size in bytes
    public private(set) var webPSize: Int?
    
    /// URL of the mp4 file
    public private(set) var mp4Url: URL?
    
    /// Gif file size in bytes
    public private(set) var mp4Size: Int?
    
    convenience init(_ id: String,
                     type: GPHMediaType,
                     rendition: GPHRenditionType,
                     gifUrl: URL,
                     gifSize: Int?,
                     width: Int?,
                     height: Int?,
                     webPUrl: URL?,
                     webPSize: Int?,
                     mp4Url: URL?,
                     mp4Size: Int?) {
        self.init()
        self.id = id
        self.type = type
        self.rendition = rendition
        self.gifUrl = gifUrl
        self.gifSize = gifSize
        self.width = width
        self.height = height
        self.webPUrl = webPUrl
        self.webPSize = webPSize
        self.mp4Url = mp4Url
        self.mp4Size = mp4Size
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let type = aDecoder.decodeObject(forKey: "type") as? GPHMediaType,
            let rendition = aDecoder.decodeObject(forKey: "rendition") as? GPHRenditionType,
            let gifUrl = aDecoder.decodeObject(forKey: "gifUrl") as? URL
            else { return nil }
        
        let gifSize = aDecoder.decodeObject(forKey: "gifSize") as? Int
        let width = aDecoder.decodeObject(forKey: "width") as? Int
        let height = aDecoder.decodeObject(forKey: "height") as? Int
        let webPUrl = aDecoder.decodeObject(forKey: "webPUrl") as? URL
        let webPSize = aDecoder.decodeObject(forKey: "webPSize") as? Int
        let mp4Url = aDecoder.decodeObject(forKey: "mp4Url") as? URL
        let mp4Size = aDecoder.decodeObject(forKey: "mp4Size") as? Int
        
        self.init(id,
                  type: type,
                  rendition: rendition,
                  gifUrl: gifUrl,
                  gifSize: gifSize,
                  width: width,
                  height: height,
                  webPUrl: webPUrl,
                  webPSize: webPSize,
                  mp4Url: mp4Url,
                  mp4Size: mp4Size)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.rendition, forKey: "rendition")
        aCoder.encode(self.gifUrl, forKey: "gifUrl")
        aCoder.encode(self.gifSize, forKey: "gifSize")
        aCoder.encode(self.width, forKey: "width")
        aCoder.encode(self.height, forKey: "height")
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
        if let other = object as? GPHImage, self.id == other.id {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_image_\(self.id)_\(self.type.hashValue)_\(self.rendition.hashValue)".hashValue
    }
    
}
