//
//  GiphyCoreSDKStatusCodeTests.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/7/17.
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

import XCTest
@testable import GiphyCoreSDK

class GiphyCoreSDKStatusCodeTests: XCTestCase {
    
    // MARK: Setup Client and Tests
    
    let client = GPHClient(apiKey: "4OMJYpPoYwVpe")
    let clientProblematicApiKey = GPHClient(apiKey: "some_fake_api_key")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    // MARK: Test 401 / Not Authorized
    func testClient401() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 401 & Recieve 401 Error")
        
        let _ = clientProblematicApiKey.gifByID("some_fake_id") { (result, error) in
            
            if let error = error as NSError? {
                if error.code == 401 {
                    promise.fulfill()
                } else {
                    XCTFail("Error(\(error.code)): \(error.localizedDescription) does not match 401!")
                }
            } else {
                XCTFail("No results?")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test 404 / Not Found
    func testClient404() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 404 & Recieve 404 Error")
        
        let _ = client.gifByID("some_fake_id") { (result, error) in
            
            if let error = error as NSError? {
                if error.code == 404 {
                  promise.fulfill()
                } else {
                  XCTFail("Error(\(error.code)): \(error.localizedDescription) does not match 404!")
                }
            } else {
                XCTFail("No results?")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
