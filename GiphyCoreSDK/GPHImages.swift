//
//  GPHImages.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/2/17.
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

/// Represents a Giphy Images (Renditions) for a GPHObject
///
@objc public class GPHImages: NSObject, NSCoding {
    
    /// ID of the Represented Object
    public fileprivate(set) var id: String
    
    /// Original file size and file dimensions. Good for desktop use.
    public fileprivate(set) var original: GPHImage?
    
    /// Preview image for original.
    public fileprivate(set) var originalStill: GPHImage?
    
    /// File size under 50kb. Duration may be truncated to meet file size requirements. Good for thumbnails and previews.
    public fileprivate(set) var preview: GPHImage?
    
    /// Duration set to loop for 15 seconds. Only recommended for this exact use case.
    public fileprivate(set) var looping: GPHImage?
    
    /// Height set to 200px. Good for mobile use.
    public fileprivate(set) var fixedHeight: GPHImage?
    
    /// Static preview image for fixed_height
    public fileprivate(set) var fixedHeightStill: GPHImage?
    
    /// Height set to 200px. Reduced to 6 frames to minimize file size to the lowest.
    /// Works well for unlimited scroll on mobile and as animated previews. See Giphy.com on mobile web as an example.
    public fileprivate(set) var fixedHeightDownsampled: GPHImage?
    
    /// Height set to 100px. Good for mobile keyboards.
    public fileprivate(set) var fixedHeightSmall: GPHImage?
    
    /// Static preview image for fixed_height_small
    public fileprivate(set) var fixedHeightSmallStill: GPHImage?

    /// Width set to 200px. Good for mobile use.
    public fileprivate(set) var fixedWidth: GPHImage?
    
    /// Static preview image for fixed_width
    public fileprivate(set) var fixedWidthStill: GPHImage?
    
    /// Width set to 200px. Reduced to 6 frames. Works well for unlimited scroll on mobile and as animated previews.
    public fileprivate(set) var fixedWidthDownsampled: GPHImage?
    
    /// Width set to 100px. Good for mobile keyboards.
    public fileprivate(set) var fixedWidthSmall: GPHImage?
    
    /// Static preview image for fixed_width_small
    public fileprivate(set) var fixedWidthSmallStill: GPHImage?
    
    /// File size under 2mb.
    public fileprivate(set) var downsized: GPHImage?

    /// File size under 200kb.
    public fileprivate(set) var downsizedSmall: GPHImage?
    
    /// File size under 5mb.
    public fileprivate(set) var downsizedMedium: GPHImage?
    
    /// File size under 8mb.
    public fileprivate(set) var downsizedLarge: GPHImage?
    
    /// Static preview image for downsized.
    public fileprivate(set) var downsizedStill: GPHImage?
    
    override public init() {
        self.id = ""
        super.init()
    }
    
    convenience init(_ id: String) {
        self.init()
        self.id = id
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id") as? String
        else {
            return nil
        }
        
        self.init(id)
        
        self.original = aDecoder.decodeObject(forKey: "original") as? GPHImage
        self.originalStill = aDecoder.decodeObject(forKey: "originalStill") as? GPHImage
        self.preview = aDecoder.decodeObject(forKey: "preview") as? GPHImage
        self.looping = aDecoder.decodeObject(forKey: "looping") as? GPHImage
        self.fixedHeight = aDecoder.decodeObject(forKey: "fixedHeight") as? GPHImage
        self.fixedHeightStill = aDecoder.decodeObject(forKey: "fixedHeightStill") as? GPHImage
        self.fixedHeightDownsampled = aDecoder.decodeObject(forKey: "fixedHeightDownsampled") as? GPHImage
        self.fixedHeightSmall = aDecoder.decodeObject(forKey: "fixedHeightSmall") as? GPHImage
        self.fixedHeightSmallStill = aDecoder.decodeObject(forKey: "fixedHeightSmallStill") as? GPHImage
        self.fixedWidth = aDecoder.decodeObject(forKey: "fixedWidth") as? GPHImage
        self.fixedWidthStill = aDecoder.decodeObject(forKey: "fixedWidthStill") as? GPHImage
        self.fixedWidthDownsampled = aDecoder.decodeObject(forKey: "fixedWidthDownsampled") as? GPHImage
        self.fixedWidthSmall = aDecoder.decodeObject(forKey: "fixedWidthSmall") as? GPHImage
        self.fixedWidthSmallStill = aDecoder.decodeObject(forKey: "fixedWidthSmallStill") as? GPHImage
        self.downsized = aDecoder.decodeObject(forKey: "downsized") as? GPHImage
        self.downsizedSmall = aDecoder.decodeObject(forKey: "downsizedSmall") as? GPHImage
        self.downsizedMedium = aDecoder.decodeObject(forKey: "downsizedMedium") as? GPHImage
        self.downsizedLarge = aDecoder.decodeObject(forKey: "downsizedLarge") as? GPHImage
        self.downsizedStill = aDecoder.decodeObject(forKey: "downsizedStill") as? GPHImage

    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.original, forKey: "original")
        aCoder.encode(self.originalStill, forKey: "originalStill")
        aCoder.encode(self.preview, forKey: "preview")
        aCoder.encode(self.looping, forKey: "looping")
        aCoder.encode(self.fixedHeight, forKey: "fixedHeight")
        aCoder.encode(self.fixedHeightStill, forKey: "fixedHeightStill")
        aCoder.encode(self.fixedHeightDownsampled, forKey: "fixedHeightDownsampled")
        aCoder.encode(self.fixedHeightSmall, forKey: "fixedHeightSmall")
        aCoder.encode(self.fixedHeightSmallStill, forKey: "fixedHeightSmallStill")
        aCoder.encode(self.fixedWidth, forKey: "fixedWidth")
        aCoder.encode(self.fixedWidthStill, forKey: "fixedWidthStill")
        aCoder.encode(self.fixedWidthDownsampled, forKey: "fixedWidthDownsampled")
        aCoder.encode(self.fixedWidthSmall, forKey: "fixedWidthSmall")
        aCoder.encode(self.fixedWidthSmallStill, forKey: "fixedWidthSmallStill")
        aCoder.encode(self.downsized, forKey: "downsized")
        aCoder.encode(self.downsizedSmall, forKey: "downsizedSmall")
        aCoder.encode(self.downsizedMedium, forKey: "downsizedMedium")
        aCoder.encode(self.downsizedLarge, forKey: "downsizedLarge")
        aCoder.encode(self.downsizedStill, forKey: "downsizedStill")

    }
    
    // MARK: NSCoder Hash and Equality/Identity
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHImages === self {
            return true
        }
        if let other = object as? GPHImages, self.id == other.id {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_renditions_\(self.id)".hashValue
    }

}

// MARK: Human readable

/// Make objects human readable
///
extension GPHImages {
    
    override public var description: String {
        return "GPHImages(for: \(self.id))"
    }
    
}

// MARK: Parsing & Mapping

/// For parsing/mapping protocol
///
extension GPHImages: GPHMappable {
    
    // convinience method to get GPHImage or nil safely
    private static func image(_ id: String,
                              data jsonData: GPHJSONObject,
                              request requestType: GPHRequestType,
                              media mediaType: GPHMediaType,
                              rendition renditionType: GPHRenditionType) -> (object: GPHImage?, error: GPHJSONMappingError?) {
        
        if let jsonKeyData = jsonData[renditionType.rawValue] as? GPHJSONObject {
            let keyImage = GPHImage.mapData(id, data: jsonKeyData, request: requestType, media: mediaType, rendition: renditionType)
            if let image = keyImage.object {
                return (image, nil)
            } else {
                // fail? or return nil -- this is conditional depending on the end-point
                if keyImage.error == nil {
                    return (nil, GPHJSONMappingError(description: "Fatal error, this should never happen"))
                }
                return (nil, keyImage.error)
            }
        }
        return (nil, GPHJSONMappingError(description: "Couldn't map GPHImage for the rendition \(renditionType.rawValue)"))
    }
    
    /// this is where the magic will happen + error handling
    public static func mapData(_ id: String,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHImages?, error: GPHJSONMappingError?) {
        
        
        let obj = GPHImages(id)
        
        obj.original = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .original).object
        obj.originalStill = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .originalStill).object
        obj.preview = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .preview).object
        obj.looping = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .looping).object
        obj.fixedHeight = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedHeight).object
        obj.fixedHeightStill = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedHeightStill).object
        obj.fixedHeightDownsampled = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedHeightDownsampled).object
        obj.fixedHeightSmall = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition:.fixedHeightSmall).object
        obj.fixedHeightSmallStill = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedHeightSmallStill).object
        obj.fixedWidth = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedWidth).object
        obj.fixedWidthStill = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedWidthStill).object
        obj.fixedWidthDownsampled = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedWidthDownsampled).object
        obj.fixedWidthSmall = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedWidthSmall).object
        obj.fixedWidthSmallStill = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .fixedWidthSmallStill).object
        obj.downsized = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .downsized).object
        obj.downsizedSmall = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .downsizedSmall).object
        obj.downsizedMedium = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .downsizedMedium).object
        obj.downsizedLarge = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .downsizedLarge).object
        obj.downsizedStill = GPHImages.image(id, data: jsonData, request: requestType, media: mediaType, rendition: .downsizedStill).object
        
        return (obj, nil)

    }
    
}



