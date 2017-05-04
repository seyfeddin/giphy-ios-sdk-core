//
//  GiphyCoreSDKParsingTests.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/4/17.
//  Copyright © 2017 Giphy. All rights reserved.
//

import XCTest
@testable import GiphyCoreSDK

class GiphyCoreSDKParsingTests: XCTestCase {
    
    let client = GPHClient(apiKey: "4OMJYpPoYwVpe")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClientSearchGIFsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.search("cats") { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let results = results  {
                
                for result in results {
                    print(result)
                }
                
                promise.fulfill()
                
            } else {
                XCTFail("No results?")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testClientSearchStickersMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.search("cats", media: .sticker) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let results = results  {
                
                for result in results {
                    print(result)
                }
                
                promise.fulfill()
                
            } else {
                XCTFail("No results?")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testClientTrendingGIFsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.trending(completionHandler: { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let results = results  {
                
                for result in results {
                    print(result)
                }
                
                promise.fulfill()
                
            } else {
                XCTFail("No results?")
            }
        })
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testClientTrendingStickersMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.trending(.sticker) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let results = results  {
                
                for result in results {
                    print(result)
                }
                
                promise.fulfill()
                
            } else {
                XCTFail("No results?")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testClientTranslateGIFsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Translate Result & Map it to Object")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.translate("cats") { (result, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let result = result  {
                print(result)
                promise.fulfill()
                
            } else {
                XCTFail("No results?")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testClientTranslateStickersMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Translate Result & Map it to Object")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.translate("cats", media: .sticker) { (result, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let result = result  {
                print(result)
                promise.fulfill()
                
            } else {
                XCTFail("No results?")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    
}
