//
//  GiphyCoreSDKParsingTests.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/4/17.
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
        
        let _ = client.search("ryan gosling") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                for result in data {
                    print(result)
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testClientSearchStickersMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        
        let _ = client.search("cats", media: .sticker) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                for result in data {
                    print(result)
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Trending

    func testClientTrendingGIFsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        
        let _ = client.trending(completionHandler: { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                for result in data {
                    print(result)
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testClientTrendingStickersMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        
        let _ = client.trending(.sticker) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                for result in data {
                    print(result)
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Translate
    
    func testClientTranslateGIFMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Translate Result & Map it to Object")
        
        let _ = client.translate("cats") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data  {
                print(response.meta)
                print(data)
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testClientTranslateStickerMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Translate Result & Map it to Object")
        
        let _ = client.translate("cats", media: .sticker) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data  {
                print(response.meta)
                print(data)
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Random
    
    func testClientRandomGIFMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Random Result & Map it to Object")
        
        let _ = client.random("cats") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data  {
                print(response.meta)
                print(data)
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testClientRandomStickerMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Random Result & Map it to Object")
        
        let _ = client.random("cats", media: .sticker) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data  {
                print(response.meta)
                print(data)
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    // MARK: Test Gif by ID

    func testClientGetGIFbyIDMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve a Gif by its id & Map it to Object")
        
        let _ = client.gifByID("FiGiRei2ICzzG") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data  {
                print(response.meta)
                print(data)
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: Test Gifs by IDs

    func testClientGetGIFsbyIDsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Gifs by Ids & Map them to Objects")
        let ids = ["PwyQ8ase9nuyQ", "mztEiyM7hzjDG", "5w4QZx27jDM8U"]
        
        let _ = client.gifsByIDs(ids) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                for result in data {
                    print(result)
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Term Suggestions
    
    func testClientTermSuggestionsMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Term Suggestions & Map them to Objects")
        
        let _ = client.termSuggestions("carm") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data {
                print(response.meta)
                for result in data {
                    print(result)
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Categories
    
    func testClientCategoriesMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Categories & Map them to Objects")
        
        let _ = client.categoriesForGifs() { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                for result in data {
                    print(result)
                    if result.subCategories == nil {
                        XCTFail("No SubCategories Found")
                    }
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testClientSubCategoriesMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Categories & Map them to Objects")
        
        let _ = client.subCategoriesForGifs("actions") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                for result in data {
                    print(result)
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testClientCategoryContentMapJsonToObject() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Categories & Map them to Objects")
        
        let _ = client.gifsByCategory("actions", subCategory: "cooking") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                for result in data {
                    print(result)
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
