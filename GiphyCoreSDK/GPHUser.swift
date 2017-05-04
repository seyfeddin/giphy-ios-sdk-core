//
//  GPHUser.swift
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
/// http://api.giphy.com/v1/gifs/categories/animals/cats?api_key=4OMJYpPoYwVpe

/*
 ▿ 18 elements
 ▿ 0 : 2 elements
 - key : "name"
 - value : AFV Pets
 
 ▿ 2 : 2 elements
 - key : "website_url"
 - value : http://www.afv.com

 ▿ 4 : 2 elements
 - key : "description"
 - value : Boat loads of pet gifs from America’s favorite show, “AFV”.
 
 ▿ 7 : 2 elements
 - key : "profile_url"
 - value : https://giphy.com/afvpets/
 
 ▿ 8 : 2 elements
 - key : "tumblr_url"
 - value : http://afvofficial.tumblr.com/
 
 ▿ 9 : 2 elements
 - key : "id"
 - value : 183873
 
 ▿ 10 : 2 elements
 - key : "is_public"
 - value : 1
 
 ▿ 11 : 2 elements
 - key : "attribution_display_name"
 - value : AFV Pets
 
 ▿ 13 : 2 elements
 - key : "suppress_chrome"
 - value : 0
 
 ▿ 14 : 2 elements
 - key : "facebook_url"
 - value :
 
 ▿ 15 : 2 elements
 - key : "website_display_url"
 - value : www.afv.com
 
 ▿ 16 : 2 elements
 - key : "twitter_url"
 - value : https://twitter.com/AFVOfficial
 ▿ 17 : 2 elements
 
 - key : "instagram_url"
 - value : <null>

 */
@objc public class GPHUser: NSObject, NSCoding {
    
    /// Username
    public private(set) var username: String
    
    /// Display Name for the User
    public private(set) var displayName: String?
    
    /// Twitter Handler
    public private(set) var twitter: String?
    
    /// URL of the Avatar
    public private(set) var avatarUrl: String?
    
    /// URL of the Banner
    public private(set) var bannerUrl: String?
    
    /// URL of the Profile
    public private(set) var profileUrl: String?
    
    override public init() {
        self.username = ""
        super.init()
    }
    
    convenience init(_ username: String,
                     displayName: String?,
                     twitter: String?,
                     avatarUrl: String?,
                     bannerUrl: String?,
                     profileUrl: String?) {
        self.init()
        self.username = username
        self.displayName = displayName
        self.twitter = twitter
        self.avatarUrl = avatarUrl
        self.bannerUrl = bannerUrl
        self.profileUrl = profileUrl
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let username = aDecoder.decodeObject(forKey: "username") as? String
        else {
            return nil
        }

        let displayName = aDecoder.decodeObject(forKey: "displayName") as? String
        let twitter = aDecoder.decodeObject(forKey: "twitter") as? String
        let avatarUrl = aDecoder.decodeObject(forKey: "avatarUrl") as? String
        let bannerUrl = aDecoder.decodeObject(forKey: "bannerUrl") as? String
        let profileUrl = aDecoder.decodeObject(forKey: "profileUrl") as? String

        self.init(username,
                  displayName: displayName,
                  twitter: twitter,
                  avatarUrl: avatarUrl,
                  bannerUrl: bannerUrl,
                  profileUrl: profileUrl)

    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.displayName, forKey: "displayName")
        aCoder.encode(self.twitter, forKey: "twitter")
        aCoder.encode(self.avatarUrl, forKey: "avatarUrl")
        aCoder.encode(self.bannerUrl, forKey: "bannerUrl")
        aCoder.encode(self.profileUrl, forKey: "profileUrl")
    }
    
    // MARK: NSCoder Hash and Equality/Identity
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHUser === self {
            return true
        }
        if let other = object as? GPHUser, self.username == other.username {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_user_\(self.username)".hashValue
    }
    
}

// MARK: Human readable

/// Make objects human readable
///
extension GPHUser {
    
    override public var description: String {
        return "GPHUser(\(self.username))"
    }
    
}

// MARK: Parsing & Mapping

/// For parsing/mapping protocol
///
extension GPHUser: GPHMappable {
    
    /// this is where the magic will happen + error handling
    public static func mapData(_ id: String,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHUser?, error: GPHJSONMappingError?) {
        
        guard
            let username = jsonData["username"] as? String
        else {
            return (nil, GPHJSONMappingError(description: "Couldn't map GPHUser for \(jsonData)"))
        }

        let displayName = jsonData["display_name"] as? String
        let twitter = jsonData["twitter"] as? String
        let avatarUrl = jsonData["avatar_url"] as? String
        let bannerUrl = jsonData["banner_url"] as? String
        let profileUrl = jsonData["profile_url"] as? String
        
        let obj = GPHUser(username,
                          displayName: displayName,
                          twitter: twitter,
                          avatarUrl: avatarUrl,
                          bannerUrl: bannerUrl,
                          profileUrl: profileUrl)
        
        return (obj, nil)
    }
    
}



