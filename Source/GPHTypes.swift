//
//  GPHTypes.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman on 4/22/17.
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

/// A simple NSObject replacement for native swift enums, which are creating memory leaks
/// in Xcode 8.3 and 9 Beta on iOS 10 and 11. Likely a regression of this issue:
/// http://www.openradar.me/30549163
/// "Memory leak when storing enum in class"
///
@objc public class GPHEnum : NSObject {
    public typealias RawValue = String
    
    public let rawValue: RawValue
    
    public init?(rawValue: RawValue) {
        self.rawValue = rawValue.lowercased()
        super.init()
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? GPHEnum else {
            return false
        }
        return object.rawValue == self.rawValue
    }
}


/// Represents a Giphy Object Type (GIF/Sticker/...)
///
@objc public class GPHMediaType: GPHEnum {
    /// GIF
    public static let gif = GPHMediaType(rawValue: "gif")!
    
    /// Sticker
    public static let sticker = GPHMediaType(rawValue: "sticker")!
}


/// Represents a Giphy Rendition Type
///
@objc public class GPHRenditionType: GPHEnum {
    /// Original file size and file dimensions. Good for desktop use.
    public static let original = GPHRenditionType(rawValue: "original")!
    
    /// Preview image for original.
    public static let originalStill = GPHRenditionType(rawValue: "original_still")!
    
    /// File size under 50kb. Duration may be truncated to meet file size requirements. Good for thumbnails and previews.
    public static let preview = GPHRenditionType(rawValue: "preview")!
    
    /// Duration set to loop for 15 seconds. Only recommended for this exact use case.
    public static let looping = GPHRenditionType(rawValue: "looping")!
    
    /// Height set to 200px. Good for mobile use.
    public static let fixedHeight = GPHRenditionType(rawValue: "fixed_height")!
    
    /// Static preview image for fixed_height
    public static let fixedHeightStill = GPHRenditionType(rawValue: "fixed_height_still")!
    
    /// Height set to 200px. Reduced to 6 frames to minimize file size to the lowest.
    /// Works well for unlimited scroll on mobile and as animated previews. See Giphy.com on mobile web as an example.
    public static let fixedHeightDownsampled = GPHRenditionType(rawValue: "fixed_height_downsampled")!
    
    /// Static preview image for fixed_height
    public static let fixedHeightSmall = GPHRenditionType(rawValue: "fixed_height_small")!
    
    /// Static preview image for fixed_height_small
    public static let fixedHeightSmallStill = GPHRenditionType(rawValue: "fixed_height_small_still")!
    
    /// Width set to 200px. Good for mobile use.
    public static let fixedWidth = GPHRenditionType(rawValue: "fixed_width")!
    
    /// Static preview image for fixed_height_small
    public static let fixedWidthStill = GPHRenditionType(rawValue: "fixed_width_still")!
    
    /// Width set to 200px. Reduced to 6 frames. Works well for unlimited scroll on mobile and as animated previews.
    public static let fixedWidthDownsampled = GPHRenditionType(rawValue: "fixed_width_downsampled")!
    
    /// Width set to 100px. Good for mobile keyboards.
    public static let fixedWidthSmall = GPHRenditionType(rawValue: "fixed_width_small")!

    /// Static preview image for fixed_width_small
    public static let fixedWidthSmallStill = GPHRenditionType(rawValue: "fixed_width_small_still")!
    
    /// File size under 2mb.
    public static let downsized = GPHRenditionType(rawValue: "downsized")!
    
    /// File size under 200kb.
    public static let downsizedSmall = GPHRenditionType(rawValue: "downsized_small")!
    
    /// File size under 5mb.
    public static let downsizedMedium = GPHRenditionType(rawValue: "downsized_medium")!
    
    /// File size under 8mb.
    public static let downsizedLarge = GPHRenditionType(rawValue: "downsized_large")!
    
    /// Static preview image for downsized.
    public static let downsizedStill = GPHRenditionType(rawValue: "downsized_still")!
}


/// Represents Giphy APIs Supported Languages
///
@objc public class GPHLanguageType: GPHEnum {
    /// English (en)
    public static let english = GPHLanguageType(rawValue: "en")!
    
    /// Spanish (es)
    public static let spanish = GPHLanguageType(rawValue: "es")!
    
    /// Portugese (pt)
    public static let portuguese = GPHLanguageType(rawValue: "pt")!
    
    /// Indonesian (id)
    public static let indonesian = GPHLanguageType(rawValue: "id")!
    
    /// French (fr)
    public static let french = GPHLanguageType(rawValue: "fr")!
    
    /// Arabic (ar)
    public static let arabic = GPHLanguageType(rawValue: "ar")!
    
    /// Turkish (tr)
    public static let turkish = GPHLanguageType(rawValue: "tr")!
    
    /// Thai (th)
    public static let thai = GPHLanguageType(rawValue: "th")!
    
    /// Vietnamese (vi)
    public static let vietnamese = GPHLanguageType(rawValue: "vi")!
    
    /// German (de)
    public static let german = GPHLanguageType(rawValue: "de")!
    
    /// Italian (it)
    public static let italian = GPHLanguageType(rawValue: "it")!
    
    /// Japanese (ja)
    public static let japanese = GPHLanguageType(rawValue: "ja")!
    
    /// Chinese Simplified (zh-cn)
    public static let chineseSimplified = GPHLanguageType(rawValue: "zh-cn")!
    
    /// Chinese Traditional (zh-tw)
    public static let chineseTraditional = GPHLanguageType(rawValue: "zh-tw")!
    
    /// Russian (ru)
    public static let russian = GPHLanguageType(rawValue: "ru")!
    
    /// Korean (ko)
    public static let korean = GPHLanguageType(rawValue: "ko")!
    
    /// Polish (pl)
    public static let polish = GPHLanguageType(rawValue: "pl")!
    
    /// Dutch (nl)
    public static let dutch = GPHLanguageType(rawValue: "nl")!
    
    /// Romanian (ro)
    public static let romanian = GPHLanguageType(rawValue: "ro")!
    
    /// Hungarian (hu)
    public static let hungarian = GPHLanguageType(rawValue: "hu")!
    
    /// Swedish (sv)
    public static let swedish = GPHLanguageType(rawValue: "sv")!
    
    /// Czech (cs)
    public static let czech = GPHLanguageType(rawValue: "cs")!
    
    /// Hindi (hi)
    public static let hindi = GPHLanguageType(rawValue: "hi")!
    
    /// Bengali (bn)
    public static let bengali = GPHLanguageType(rawValue: "bn")!
    
    /// Danish (da)
    public static let danish = GPHLanguageType(rawValue: "da")!
    
    /// Farsi (fa)
    public static let farsi = GPHLanguageType(rawValue: "fa")!
    
    /// Filipino (tl)
    public static let filipino = GPHLanguageType(rawValue: "tl")!
    
    /// Finnish (fi)
    public static let finnish = GPHLanguageType(rawValue: "fi")!
    
    /// Hebrew (iw)
    public static let hebrew = GPHLanguageType(rawValue: "iw")!
    
    /// Malay (ms)
    public static let malay = GPHLanguageType(rawValue: "ms")!
    
    /// Norwegian (no)
    public static let norwegian = GPHLanguageType(rawValue: "no")!
    
    /// Ukranian (uk)
    public static let ukrainian = GPHLanguageType(rawValue: "uk")!
}


/// Represents content rating (y,g, pg, pg-13 or r)
///
@objc public class GPHRatingType: GPHEnum {
    /// Rated Y
    public static let ratedY = GPHRatingType(rawValue: "y")!
    
    /// Rated G
    public static let ratedG = GPHRatingType(rawValue: "g")!
    
    /// Rated PG
    public static let ratedPG = GPHRatingType(rawValue: "pg")!
    
    /// Rated PG-13
    public static let ratedPG13 = GPHRatingType(rawValue: "pg-13")!
    
    /// Rated R
    public static let ratedR = GPHRatingType(rawValue: "r")!
    
    /// Not Safe for Work
    public static let nsfw = GPHRatingType(rawValue: "nsfw")!
    
    /// Unrated
    public static let unrated = GPHRatingType(rawValue: "unrated")!
}
