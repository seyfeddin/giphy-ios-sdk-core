//
//  GPHResponse.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman on 5/8/17.
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
@objc public class GPHResponse: NSObject {
    // MARK: Properties

    /// Message description.
    public internal(set) var meta: GPHMeta
    
    
    // MARK: Initializers
    
    /// Initializer
    ///
    override public init() {
        self.meta = GPHMeta()
        super.init()
    }
    
    /// Convenience Initializer
    ///
    /// - parameter meta: init with a GPHMeta object.
    ///
    convenience public init(_ meta: GPHMeta) {
        self.init()
        self.meta = meta
    }
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHResponse {
    
    override public var description: String {
        return "GPHResponse(\(self.meta.responseId) status: \(self.meta.status) msg: \(self.meta.msg))"
    }
    
}
