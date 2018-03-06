//
//  GPHStatefulRequest.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 3/6/18.
//  Copyright © 2018 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation


@objc
class GPHStatefulRequest: GPHRequest {
    
    var items:[GPHFilterable] = []
    var retryTimer:Timer? = nil
    var hasRequestInFlight: Bool = false
    
    func newRequest(force: Bool) {}
    func resetRequest() {}
    func retryRequest() {}
    func cancelRequest() {}
    func cancelRetry() {}
    
}
