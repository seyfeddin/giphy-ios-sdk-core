//
//  GiphyCoreSDKTests.swift
//  GiphyCoreSDKTests
//
//  Created by Cem Kozinoglu on 4/22/17.
//  Copyright © 2017 Giphy. All rights reserved.
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
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.search("cats") { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    func testClientSearchGIFsOffsetLimit() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results")
        var statusCode: Int?
        var responseError: Error?
        
        client.search("cats", media:.gif, offset: 0, limit: 4) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
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
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    func testClientSearchStickers() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results")
        var statusCode: Int?
        var responseError: Error?
        
        client.search("cats", media: .sticker) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    func testClientSearchStickersOffsetLimit() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results")
        var statusCode: Int?
        var responseError: Error?
        
        client.search("cats", media:.sticker, offset: 0, limit: 4) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
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
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    func testClientTrendingGIFs() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Trending Results")
        var statusCode: Int?
        var responseError: Error?
        
        client.trending() { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

    
    func testClientTrendingStickers() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Trending Results")
        var statusCode: Int?
        var responseError: Error?
        
        client.trending(.sticker) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
}
