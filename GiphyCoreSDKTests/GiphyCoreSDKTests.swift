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
    
    func testClientApiKey() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Recieve search results")
        var statusCode: Int?
        var responseError: Error?
        
        client.search("cem") { (results, response, error) in
            print("Hello world")
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
            if results != nil {
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        //XCTAssertNil(responseError)
        //XCTAssertEqual(statusCode, 200)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
