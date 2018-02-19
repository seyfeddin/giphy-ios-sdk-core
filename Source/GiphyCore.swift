//
//  GiphyCore.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 2/17/18.
//  Copyright © 2018 Giphy. All rights reserved.
//

import Foundation

@objc public class GiphyCore: NSObject {
    
    // Singleton to interface with
    @objc public static let shared = GPHClient(apiKey: "")
    
    /// Configure the Client
    ///
    /// - parameter apiKey: Giphy Api Key to use.
    ///
    @objc public class func configure(apiKey: String) {
        shared.apiKey = apiKey
    }

}
