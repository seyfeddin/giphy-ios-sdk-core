//
//  GPHTypes.swift
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
 Represents a Giphy Object Type (Gif/Sticker/...)
 */
@objc public enum GPHMediaType: Int {
    /// Gif Media Type
    case gif
    
    /// Sticker Media Type
    case sticker
}

/**
 Represents a Giphy Object Type (Gif/Sticker/...)
 */
@objc public enum GPHRenditionType: Int, RawRepresentable {
    /// We use Int, RawRepresentable to be able to bridge btw ObjC<>Swift without loosing String values
    
    /// Height set to 200px. Good for mobile use.
    case fixedHeight
    
    /// Static preview image for fixed_height
    case fixedHeightStill
    
    /// Height set to 200px. Reduced to 6 frames to minimize file size to the lowest.
    /// Works well for unlimited scroll on mobile and as animated previews. See Giphy.com on mobile web as an example.
    case fixedHeightDownsampled
    
    /// Width set to 200px. Good for mobile use.
    case fixedWidth
    
    /// Static preview image for fixed_width
    case fixedWidthStill
    
    /// Width set to 200px. Reduced to 6 frames. Works well for unlimited scroll on mobile and as animated previews.
    case fixedWidthDownsampled
    
    /// Height set to 100px. Good for mobile keyboards.
    case fixedHeightSmall
    
    /// Static preview image for fixed_height_small
    case fixedHeightSmallStill
    
    /// Width set to 100px. Good for mobile keyboards.
    case fixedWidthSmall
    
    /// Static preview image for fixed_width_small
    case fixedWidthSmallStill
    
    /// File size under 50kb. Duration may be truncated to meet file size requirements. Good for thumbnails and previews.
    case preview
    
    /// File size under 200kb.
    case downsizedSmall
    
    /// File size under 2mb.
    case downsized
    
    /// File size under 5mb.
    case downsizedMedium
    
    /// File size under 8mb.
    case downsizedLarge
    
    /// Static preview image for downsized.
    case downsizedStill
    
    /// Original file size and file dimensions. Good for desktop use.
    case original
    
    /// Preview image for original.
    case originalStill
    
    /// Duration set to loop for 15 seconds. Only recommended for this exact use case.
    case looping
    
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .fixedHeight:
            return "fixed_height"
        case .fixedHeightStill:
            return "fixed_height_still"
        case .fixedHeightDownsampled:
            return "fixed_height_downsampled"
        case .fixedWidth:
            return "fixed_width"
        case .fixedWidthStill:
            return "fixed_width_still"
        case .fixedWidthDownsampled:
            return "fixed_width_downsampled"
        case .fixedHeightSmall:
            return "fixed_height_small"
        case .fixedHeightSmallStill:
            return "fixed_height_small_still"
        case .fixedWidthSmall:
            return "fixed_width_small"
        case .fixedWidthSmallStill:
            return "fixed_width_small_still"
        case .preview:
            return "preview"
        case .downsizedSmall:
            return "downsized_small"
        case .downsized:
            return "downsized"
        case .downsizedMedium:
            return "downsized_medium"
        case .downsizedLarge:
            return "downsized_large"
        case .downsizedStill:
            return "downsized_still"
        case .original:
            return "original"
        case .originalStill:
            return "original_still"
        case .looping:
            return "looping"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
            
        case "fixed_height":
            self = .fixedHeight
        case "fixed_height_still":
            self = .fixedHeightStill
        case "fixed_height_downsampled":
            self = .fixedHeightDownsampled
        case "fixed_width":
            self = .fixedWidth
        case "fixed_width_still":
            self = .fixedWidthStill
        case "fixed_width_downsampled":
            self = .fixedWidthDownsampled
        case "fixed_height_small":
            self = .fixedHeightSmall
        case "fixed_height_small_still":
            self = .fixedHeightSmallStill
        case "fixed_width_small":
            self = .fixedWidthSmall
        case "fixed_width_small_still":
            self = .fixedWidthSmallStill
        case "preview":
            self = .preview
        case "downsized_small":
            self = .downsizedSmall
        case "downsized":
            self = .downsized
        case "downsized_medium":
            self = .downsizedMedium
        case "downsized_large":
            self = .downsizedLarge
        case "downsized_still":
            self = .downsizedStill
        case "original":
            self = .original
        case "original_still":
            self = .originalStill
        case "looping":
            self = .looping
        default:
            self = .fixedHeight
        }
    }
}

/**
 Represents content rating (y,g, pg, pg-13 or r)
 */
@objc public enum GPHRatingType: Int, RawRepresentable {
/// We use Int, RawRepresentable to be able to bridge btw ObjC<>Swift without loosing String values

    /// Rated R
    case ratedR
    
    /// Rated Y
    case ratedY
    
    /// Rated G
    case ratedG
    
    /// Rated PG
    case ratedPG
    
    /// Rated PG-13
    case ratedPG13
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .ratedR:
            return "r"
        case .ratedY:
            return "y"
        case .ratedG:
            return "g"
        case .ratedPG:
            return "pg"
        case .ratedPG13:
            return "pg-13"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "r":
            self = .ratedR
        case "y":
            self = .ratedY
        case "g":
            self = .ratedG
        case "pg":
            self = .ratedPG
        case "pg-13":
            self = .ratedPG13
        default:
            self = .ratedR
        }
    }
    
}
