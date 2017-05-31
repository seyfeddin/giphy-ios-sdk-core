//
//  GiphyCoreSDKNSCodingTests.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 5/23/17.
//  Copyright © 2017 Giphy. All rights reserved.
//

import XCTest
@testable import GiphyCoreSDK

extension XCTestCase {
    func cloneViaCoding<T: NSCoding>(root: T) throws -> T {
        let data = NSKeyedArchiver.archivedData(withRootObject: root)
        guard let res = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else {
            throw NSError(domain: "com.giphy.sdk", code: 100, userInfo: [NSLocalizedDescriptionKey: "Can not unarchive object"])
        }
        return res
    }
}

class GiphyCoreSDKNSCodingTests: XCTestCase {
    
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
    
    func testNSCodingForSearchGIFs() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        
        let _ = client.search("cats") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNSCodingForSearchStickers() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        
        let _ = client.search("cats", media: .sticker) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testNSCodingForTrendingGIFs() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        
        let _ = client.trending(completionHandler: { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNSCodingForTrendingStickers() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Search Results & Map them to Objects")
        
        let _ = client.trending(.sticker) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Translate
    
    func testNSCodingForTranslateGIF() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Translate Result & Map it to Object")
        
        let _ = client.translate("cats") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let result = response.data  {
                print(response.meta)
                do {
                    try _ = self.cloneViaCoding(root: result)
                } catch let error as NSError {
                    print(result)
                    print(error)
                    XCTFail("Failed to archive and unarchive")
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNSCodingForTranslateSticker() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Translate Result & Map it to Object")
        
        let _ = client.translate("cats", media: .sticker) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let result = response.data  {
                print(response.meta)
                do {
                    try _ = self.cloneViaCoding(root: result)
                } catch let error as NSError {
                    print(result)
                    print(error)
                    XCTFail("Failed to archive and unarchive")
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Random
    
    func testNSCodingForRandomGIF() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Random Result & Map it to Object")
        
        let _ = client.random("cats") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let result = response.data  {
                print(response.meta)
                do {
                    try _ = self.cloneViaCoding(root: result)
                } catch let error as NSError {
                    print(result)
                    print(error)
                    XCTFail("Failed to archive and unarchive")
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNSCodingForRandomSticker() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Random Result & Map it to Object")
        
        let _ = client.random("cats", media: .sticker) { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let result = response.data  {
                print(response.meta)
                do {
                    try _ = self.cloneViaCoding(root: result)
                } catch let error as NSError {
                    print(result)
                    print(error)
                    XCTFail("Failed to archive and unarchive")
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    // MARK: Test Gif by ID
    
    func testNSCodingForGetGIFbyID() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve a Gif by its id & Map it to Object")
        
        let _ = client.gifByID("FiGiRei2ICzzG") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let result = response.data  {
                print(response.meta)
                do {
                    try _ = self.cloneViaCoding(root: result)
                } catch let error as NSError {
                    print(result)
                    print(error)
                    XCTFail("Failed to archive and unarchive")
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
            
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Gifs by IDs
    
    func testNSCodingForGetGIFsbyIDs() {
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
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Term Suggestions
    
    func testNSCodingForTermSuggestions() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Term Suggestions & Map them to Objects")
        
        let _ = client.termSuggestions("carm") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data {
                print(response.meta)
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: Test Categories
    
    func testNSCodingForCategories() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Categories & Map them to Objects")
        
        let _ = client.categoriesForGifs() { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNSCodingForSubCategories() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Categories & Map them to Objects")
        
        let _ = client.subCategoriesForGifs("actions") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNSCodingForCategoryContent() {
        // Test to see if we can do a valid search request with our Client Api Key
        let promise = expectation(description: "Status 200 & Recieve Categories & Map them to Objects")
        
        let _ = client.gifsByCategory("actions", subCategory: "cooking") { (response, error) in
            
            if let error = error as NSError? {
                XCTFail("Error(\(error.code)): \(error.localizedDescription)")
            }
            
            if let response = response, let data = response.data, let pagination = response.pagination {
                print(response.meta)
                print(pagination)
                data.forEach { result in
                    do {
                        try _ = self.cloneViaCoding(root: result)
                    } catch let error as NSError {
                        print(result)
                        print(error)
                        XCTFail("Failed to archive and unarchive")
                    }
                }
                promise.fulfill()
            } else {
                XCTFail("No Result Found")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    
    
}
