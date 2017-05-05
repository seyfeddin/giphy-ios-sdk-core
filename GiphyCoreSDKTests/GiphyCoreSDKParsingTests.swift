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
    
    // MARK: Test Search

    func testClientSearchGIFsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.search("ryan gosling") { (results, response, error) in
            
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
    
    // MARK: Test Trending

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
    
    // MARK: Test Translate
    
    func testClientTranslateGIFMapJsonToObject() {
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
    
    func testClientTranslateStickerMapJsonToObject() {
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
    
    // MARK: Test Random
    
    func testClientRandomGIFMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Random Result & Map it to Object")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.random("cats") { (result, response, error) in
            
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
    
    func testClientRandomStickerMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Random Result & Map it to Object")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.random("cats", media: .sticker) { (result, response, error) in
            
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
    
    
    // MARK: Test Gif by ID

    func testClientGetGIFbyIDMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve a Gif by its id & Map it to Object")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.gifByID("FiGiRei2ICzzG") { (result, response, error) in
            
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

    // MARK: Test Gifs by IDs

    func testClientGetGIFsbyIDsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Gifs by Ids & Map them to Objects")
        var statusCode: Int?
        var responseError: Error?
        let ids = ["PwyQ8ase9nuyQ", "mztEiyM7hzjDG", "5w4QZx27jDM8U"]
        
        let _ = client.gifsByIDs(ids) { (results, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                responseError = error
                XCTFail("Error: \(error.localizedDescription)")
            }
            if let results = results {
                for result in results {
                    print(result)
                }
                if results.count != ids.count {
                    XCTFail("Number of gifs requested and parsed don't match")
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
    
    // MARK: Test Term Suggestions
    
    func testClientTermSuggestionsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Term Suggestions & Map them to Objects")
        var statusCode: Int?
        var responseError: Error?
        
        let _ = client.termSuggestions("carm") { (results, response, error) in
            
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
    
}
