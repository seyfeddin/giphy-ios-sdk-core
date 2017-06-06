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

/// Represents a Giphy User Object
///
/// http://api.giphy.com/v1/gifs/categories/animals/cats?api_key=4OMJYpPoYwVpe

@objc public class GPHUser: NSObject, NSCoding {
    // MARK: Properties
    
    /// Username.
    public fileprivate(set) var username: String

    /// User Public/Private.
    public fileprivate(set) var isPublic: Bool?

    /// User ID.
    public fileprivate(set) var id: Int?
    
    /// Name of the User.
    public fileprivate(set) var name: String?
    
    /// Description of the User.
    public fileprivate(set) var userDescription: String?

    /// Attribution Display Name.
    public fileprivate(set) var attributionDisplayName: String?
    
    /// Display Name for the User.
    public fileprivate(set) var displayName: String?
    
    /// Twitter Handler.
    public fileprivate(set) var twitter: String?

    /// URL of the Twitter Handler.
    public fileprivate(set) var twitterUrl: String?

    /// URL of the Facebook Handler.
    public fileprivate(set) var facebookUrl: String?

    /// URL of the Instagram Handler.
    public fileprivate(set) var instagramUrl: String?
    
    /// URL of the Website
    public fileprivate(set) var websiteUrl: String?

    /// Displayable URL of the Website.
    public fileprivate(set) var websiteDisplayUrl: String?
    
    /// URL of the Tumblr Handler.
    public fileprivate(set) var tumblrUrl: String?
    
    /// URL of the Avatar.
    public fileprivate(set) var avatarUrl: String?
    
    /// URL of the Banner.
    public fileprivate(set) var bannerUrl: String?
    
    /// URL of the Profile.
    public fileprivate(set) var profileUrl: String?

    /// Suppress Chrome.
    public fileprivate(set) var suppressChrome: Bool?
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    // MARK: Initilizers
    
    /// Initilizer
    ///
    override public init() {
        self.username = ""
        super.init()
    }
    
    /// Convenience Initilizer
    ///
    /// - parameter username: Username of the User.
    ///
    convenience public init(_ username: String) {
        self.init()
        self.username = username
    }
    
    //MARK: NSCoding
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let username = aDecoder.decodeObject(forKey: "username") as? String
        else {
            return nil
        }
        
        self.init(username)
        
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.isPublic = aDecoder.decodeObject(forKey: "isPublic") as? Bool
        self.suppressChrome = aDecoder.decodeObject(forKey: "suppressChrome") as? Bool
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.displayName = aDecoder.decodeObject(forKey: "displayName") as? String
        self.userDescription = aDecoder.decodeObject(forKey: "userDescription") as? String
        self.attributionDisplayName = aDecoder.decodeObject(forKey: "attributionDisplayName") as? String
        self.twitter = aDecoder.decodeObject(forKey: "twitter") as? String
        self.twitterUrl = aDecoder.decodeObject(forKey: "twitterUrl") as? String
        self.facebookUrl = aDecoder.decodeObject(forKey: "facebookUrl") as? String
        self.instagramUrl = aDecoder.decodeObject(forKey: "instagramUrl") as? String
        self.websiteUrl = aDecoder.decodeObject(forKey: "websiteUrl") as? String
        self.websiteDisplayUrl = aDecoder.decodeObject(forKey: "websiteDisplayUrl") as? String
        self.tumblrUrl = aDecoder.decodeObject(forKey: "tumblrUrl") as? String
        self.avatarUrl = aDecoder.decodeObject(forKey: "avatarUrl") as? String
        self.bannerUrl = aDecoder.decodeObject(forKey: "bannerUrl") as? String
        self.profileUrl = aDecoder.decodeObject(forKey: "profileUrl") as? String
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.isPublic, forKey: "isPublic")
        aCoder.encode(self.suppressChrome, forKey: "suppressChrome")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.displayName, forKey: "displayName")
        aCoder.encode(self.userDescription, forKey: "userDescription")
        aCoder.encode(self.attributionDisplayName, forKey: "attributionDisplayName")
        aCoder.encode(self.twitter, forKey: "twitter")
        aCoder.encode(self.twitterUrl, forKey: "twitterUrl")
        aCoder.encode(self.facebookUrl, forKey: "facebookUrl")
        aCoder.encode(self.instagramUrl, forKey: "instagramUrl")
        aCoder.encode(self.websiteUrl, forKey: "websiteUrl")
        aCoder.encode(self.websiteDisplayUrl, forKey: "websiteDisplayUrl")
        aCoder.encode(self.tumblrUrl, forKey: "tumblrUrl")
        aCoder.encode(self.avatarUrl, forKey: "avatarUrl")
        aCoder.encode(self.bannerUrl, forKey: "bannerUrl")
        aCoder.encode(self.profileUrl, forKey: "profileUrl")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
    }
    
    // MARK: NSObject

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

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHUser {
    
    override public var description: String {
        return "GPHUser(\(self.username))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHUser: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    static func mapData(_ root: GPHMedia?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHUser?, error: GPHJSONMappingError?) {
        
        guard
            let username = jsonData["username"] as? String
        else {
            return (nil, GPHJSONMappingError(description: "Couldn't map GPHUser for \(jsonData)"))
        }
       
        let obj = GPHUser(username)

        obj.id = parseInt(jsonData["id"] as? String)
        obj.isPublic = jsonData["is_public"] as? Bool
        obj.suppressChrome = jsonData["suppress_chrome"] as? Bool
        obj.name = jsonData["name"] as? String
        obj.displayName = jsonData["display_name"] as? String
        obj.userDescription = jsonData["user_description"] as? String
        obj.attributionDisplayName = jsonData["attribution_display_name"] as? String
        obj.twitter = jsonData["twitter"] as? String
        obj.twitterUrl = jsonData["twitter_url"] as? String
        obj.facebookUrl = jsonData["facebook_url"] as? String
        obj.instagramUrl = jsonData["instagram_url"] as? String
        obj.websiteUrl = jsonData["website_url"] as? String
        obj.websiteDisplayUrl = jsonData["website_display_url"] as? String
        obj.tumblrUrl = jsonData["tumblr_url"] as? String
        obj.avatarUrl = jsonData["avatar_url"] as? String
        obj.bannerUrl = jsonData["banner_url"] as? String
        obj.profileUrl = jsonData["profile_url"] as? String
        obj.jsonRepresentation = jsonData
        
        return (obj, nil)
    }
    
}
