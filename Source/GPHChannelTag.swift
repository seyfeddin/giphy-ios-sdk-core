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

/// Represents Giphy A Channel Tag Object
///
@objc public class GPHChannelTag: NSObject, NSCoding {
    // MARK: Properties
    
    /// ID of this Channel.
    public fileprivate(set) var id: Int?
    
    /// Slug of the Channel.
    public fileprivate(set) var channel: Int?
    
    /// Display name of the Channel.
    public fileprivate(set) var tag: String?
    
    /// Shortd display name of the Channel.
    public fileprivate(set) var rank: Int?
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init()
        
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.channel = aDecoder.decodeObject(forKey: "channel") as? Int
        self.tag = aDecoder.decodeObject(forKey: "tag") as? String
        self.rank = aDecoder.decodeObject(forKey: "rank") as? Int
        
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.channel, forKey: "channel")
        aCoder.encode(self.tag, forKey: "tag")
        aCoder.encode(self.rank, forKey: "rank")

        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
    }
}

/// Make objects human readable.
///
extension GPHChannelTag {
    
    override public var description: String {
        return "GPHChannelTag(\(self.tag))"
    }
    
}

extension GPHChannelTag: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    static func mapData(_ root: GPHChannelTag?,
                        data jsonData: GPHJSONObject,
                        request requestType: GPHRequestType,
                        media mediaType: GPHMediaType = .gif,
                        rendition renditionType: GPHRenditionType = .original) throws -> GPHChannelTag {
        
        let obj = GPHChannelTag()
        
        obj.id = (jsonData["id"] as? Int)
        obj.channel = (jsonData["channel"] as? Int)
        obj.tag = (jsonData["tag"] as? String)
        obj.rank = (jsonData["rank"] as? Int)
        
        obj.jsonRepresentation = jsonData
        
        return obj
    }
    
}
