//
//  GPHListTermSuggestionResponse.swift
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

/// Represents a Giphy List Term Suggestions Response (multiple results)
///
@objc public class GPHListTermSuggestionResponse: GPHResponse {
    // MARK: Properties

    /// Terms Suggested.
    public fileprivate(set) var data: [GPHTermSuggestion]?
    
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter meta: init with a GPHMeta object.
    /// - parameter data: GPHTermSuggestion array (optional).
    ///
    convenience public init(_ meta:GPHMeta, data: [GPHTermSuggestion]?) {
        self.init()
        self.data = data
        self.meta = meta
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHListTermSuggestionResponse {
    
    override public var description: String {
        return "GPHListTermSuggestionResponse(\(self.meta.responseId) status: \(self.meta.status) msg: \(self.meta.msg))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHListTermSuggestionResponse: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    static func mapData(_ root: GPHTermSuggestion?,
                               data jsonData: GPHJSONObject,
                               request requestType: GPHRequestType,
                               media mediaType: GPHMediaType = .gif,
                               rendition renditionType: GPHRenditionType = .original) -> (object: GPHListTermSuggestionResponse?, error: GPHJSONMappingError?) {
        
        guard
            let metaData = jsonData["meta"] as? GPHJSONObject
            else {
                return (nil, GPHJSONMappingError(description: "Couldn't map GPHMediaResponse due to Meta missing for \(jsonData)"))
        }
        
        let meta = GPHMeta.mapData(nil, data: metaData, request: requestType, media: mediaType, rendition: renditionType)
        
        if let metaObj = meta.object {
            // Try to see if we can get the Media object
            if let termData = jsonData["data"] as? [GPHJSONObject] {
                
                // Get Results
                var resultObjs:[GPHTermSuggestion] = []
                
                for result in termData {
                    let resultObj = GPHTermSuggestion.mapData(nil, data: result, request: requestType, media: mediaType)
                    
                    if resultObj.object == nil {
                        if let jsonError = resultObj.error {
                            return (nil, jsonError)
                        }
                        return (nil, GPHJSONMappingError(description: "Unexpected term suggestion data error"))
                        
                    }
                    resultObjs.append(resultObj.object!)
                }
                
                // We have images and the meta data and pagination
                let obj = GPHListTermSuggestionResponse(metaObj, data: resultObjs)
                return (obj, nil)
            }
            
            // No image and pagination data, return the meta data
            let obj = GPHListTermSuggestionResponse(metaObj, data: nil)
            return (obj, nil)
        }
        
        // fail? or return nil -- this is conditional depending on the end-point
        if meta.error == nil {
            return (nil, GPHJSONMappingError(description: "Fatal error, this should never happen"))
        }
        return (nil, meta.error)
    }
    
}
