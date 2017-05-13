//
//  GPHMeta.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/8/17.
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

/// Represents a Giphy Response Meta Info
///
@objc public class GPHMeta: NSObject {
    // MARK: Properties

    /// Unique response id.
    public fileprivate(set) var responseId: String
    
    /// Status (200, 404...)
    public fileprivate(set) var status: Int
    
    /// Message description.
    public fileprivate(set) var msg: String
    
    
    // MARK: Initilizers
    
    /// Initilizer
    ///
    override public init() {
        self.responseId = ""
        self.status = 0
        self.msg = ""
        super.init()
    }
    
    /// Convenience Initilizer
    ///
    /// - parameter responseId: Unique response id.
    /// - parameter status: Status (200, 404...)
    /// - parameter msg: Message description.
    ///
    convenience init(_ responseId: String, status: Int, msg: String) {
        self.init()
        self.status = status
        self.msg = msg
        self.responseId = responseId
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHMeta {
    
    override public var description: String {
        return "GPHMeta(\(self.responseId) status: \(self.status) msg: \(self.msg))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHMeta: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ root: GPHMeta?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHMeta?, error: GPHJSONMappingError?) {
        
        guard
            let responseId = jsonData["response_id"] as? String,
            let status = jsonData["status"] as? Int,
            let msg = jsonData["msg"] as? String
            else {
                return (nil, GPHJSONMappingError(description: "Couldn't map GPHMeta for \(jsonData)"))
        }
        
        let obj = GPHMeta(responseId, status: status, msg: msg)
        
        return (obj, nil)
    }
    
}
