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
    
    // This flag isn't set until we've receive at least a first response -
    // even if it was empty.
    var hasReceivedAResponse: Bool = false
    
    // This flag is set IFF we have received a failure more recently
    // than a response.
    var hasReceivedAFailure: Bool = false
    
    // This flag is set IFF we have received an empty response, which
    // should indicate that we have "bottomed out" in the paging.
    var hasReceivedEmptyResponse: Bool = false
    
    // More reliable way of determining whether the query has returned all paginated results
    var hasAlreadyReturnedAllResults: Bool = false

    // Initiate a new request if necessary.
    //
    // 1) If force is YES, always create a new request.
    // 2) If force is NO, do not create a new request if there is already a pending retry.
    func newRequest(force: Bool) {}
    
    func resetRequest(fireEventImmediately: Bool) {}
    func retryRequest() {}
    func cancelRequest() {}
    func cancelRetry() {}
    
}
