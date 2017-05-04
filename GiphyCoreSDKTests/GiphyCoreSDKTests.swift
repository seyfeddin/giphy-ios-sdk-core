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
        
        client.search("cats", type:.gif, offset: 0, limit: 4) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let results = results {
                print(results)
                if let counter = results["data"] as? NSArray, counter.count == 4 {
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
        
        client.search("cats", type: .sticker) { (results, response, error) in
            
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
        
        client.search("cats", type:.sticker, offset: 0, limit: 4) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let results = results {
                print(results)
                if let counter = results["data"] as? NSArray, counter.count == 4 {
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
    
    
    func testClientSearchGIFsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.search("cats") { (data, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let data = data, let results = data["data"] as? [[String:Any]]  {
                
                var resultObjs:[GPHObject] = []
                
                for result in results {
                    let resultObj = GPHObject.mapData("", data: result, request: .search, media: .gif)
                    
                    if resultObj.0 == nil {
                        if let jsonError = resultObj.1 {
                            XCTFail(jsonError.localizedDescription)
                        } else {
                            XCTFail("Error: unexpected error")
                        }
                    }
                    
                    resultObjs.append(resultObj.object!)
                }
                print(resultObjs)
                promise.fulfill()

            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
}
