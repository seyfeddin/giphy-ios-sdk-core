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

/**
 Represents a Giphy Image (Gif/Sticker)
 */
@objc public class GPHImage: NSObject, NSCoding {
    
    /// Image ID
    public private(set) var id: String!
    
    /// Display Name for the User
    public private(set) var type: GPHMediaType

    /// Rendition
    public private(set) var rendition: GPHRatingType
    
    /// Width
    public private(set) var width: Int = 0

    /// Height
    public private(set) var height: Int = 0
    
    /// URL of the Gif file
    public private(set) var gifUrl: URL?
    
    /// Gif file size in bytes
    public private(set) var gifSize: Int = 0
    
    /// URL of the WebP file
    public private(set) var webPUrl: URL?

    /// Gif file size in bytes
    public private(set) var webPSize: Int = 0
    
    /// URL of the mp4 file
    public private(set) var mp4Url: URL?
    
    /// Gif file size in bytes
    public private(set) var mp4Size: Int = 0
    
//    convenience init(_ username: String,
//                     displayName: String?,
//                     twitter: String?,
//                     avatarUrl: URL?,
//                     bannerUrl: URL?,
//                     profileUrl: URL?) {
//        self.init()
//        self.username = username
//        self.displayName = displayName
//        self.twitter = twitter
//        self.avatarUrl = avatarUrl
//        self.bannerUrl = bannerUrl
//        self.profileUrl = profileUrl
//    }
//    
//    required convenience public init?(coder aDecoder: NSCoder) {
//        guard let username = aDecoder.decodeObject(forKey: "username") as? String
//            else { return nil }
//        
//        let displayName = aDecoder.decodeObject(forKey: "displayName") as? String
//        let twitter = aDecoder.decodeObject(forKey: "twitter") as? String
//        let avatarUrl = aDecoder.decodeObject(forKey: "avatarUrl") as? URL
//        let bannerUrl = aDecoder.decodeObject(forKey: "bannerUrl") as? URL
//        let profileUrl = aDecoder.decodeObject(forKey: "profileUrl") as? URL
//        
//        self.init(username,
//                  displayName: displayName,
//                  twitter: twitter,
//                  avatarUrl: avatarUrl,
//                  bannerUrl: bannerUrl,
//                  profileUrl: profileUrl)
//        
//    }
//    
//    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.username, forKey: "username")
//        aCoder.encode(self.displayName, forKey: "displayName")
//        aCoder.encode(self.twitter, forKey: "twitter")
//        aCoder.encode(self.avatarUrl, forKey: "avatarUrl")
//        aCoder.encode(self.bannerUrl, forKey: "bannerUrl")
//        aCoder.encode(self.profileUrl, forKey: "profileUrl")
//    }
    
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
