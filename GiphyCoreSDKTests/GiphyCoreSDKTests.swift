//
//  GiphyCoreSDKTests.swift
//  GiphyCoreSDKTests
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

import XCTest
@testable import GiphyCoreSDK

class GiphyCoreSDKTests: XCTestCase {
    
    // MARK: Setup Client and Tests

    let client = GPHClient(apiKey: "4OMJYpPoYwVpe")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testClientSearchGIFs() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results")
        
        let _ = client.search("cats") { (results, pagination, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let pagination = pagination {
                print(pagination)
            } else {
                XCTFail("No Pagination")
            }
            
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    func testClientSearchGIFsOffsetLimit() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results")
        
        client.search("cats", media:.gif, offset: 0, limit: 4) { (results, pagination, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let pagination = pagination {
                print(pagination)
                if pagination.totalCount != 4 && pagination.count != 4 {
                    XCTFail("Pagination doesn't match limit of 4")
                }
            } else {
                XCTFail("No Pagination")
            }
            
            if let results = results {
                print(results)
                if results.count == 4 {
                    promise.fulfill()
                } else {
                    XCTFail("Offset/Limit is returning wrong amount of results")
                }
                
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    func testClientSearchStickers() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results")
        
        client.search("cats", media: .sticker) { (results, pagination, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let pagination = pagination {
                print(pagination)
            } else {
                XCTFail("No Pagination")
            }
            
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    func testClientSearchStickersOffsetLimit() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results")
        
        client.search("cats", media:.sticker, offset: 0, limit: 4) { (results, pagination, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let pagination = pagination {
                print(pagination)
                if pagination.totalCount != 4 && pagination.count != 4 {
                    XCTFail("Pagination doesn't match limit of 4")
                }
            } else {
                XCTFail("No Pagination")
            }
            
            if let results = results {
                print(results)
                if results.count == 4 {
                    promise.fulfill()
                } else {
                    XCTFail("Offset/Limit is returning wrong amount of results")
                }
                
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    func testClientTrendingGIFs() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Trending Results")
        
        client.trending() { (results, pagination, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }

            if let pagination = pagination {
                print(pagination)
            } else {
                XCTFail("No Pagination")
            }
            
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    
    func testClientTrendingStickers() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Trending Results")

        client.trending(.sticker) { (results, pagination, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let pagination = pagination {
                print(pagination)
            } else {
                XCTFail("No Pagination")
            }
            
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
}
