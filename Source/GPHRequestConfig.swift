//
//  GPHRequestConfig.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 3/15/18.
//  Copyright © 2018 Giphy. All rights reserved.
//

import Foundation


@objcMembers public class GPHRequestConfig:NSObject {
    
    public var method: GPHRequestType = .get
    public var queryItems: [URLQueryItem]? = nil
    public var headers: [String: String]? = nil
    public var path: String = ""
    public var requestType: String = ""
    public var options: [String: Any?]? = nil
    public var apiKey: String = ""
    
    public func getRequest() -> URLRequest {
        return GPHRequestRouter.request(path, method, queryItems, headers).asURLRequest(apiKey)
    }
}
