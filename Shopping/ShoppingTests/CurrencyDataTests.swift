//
//  CurrencyDataTests.swift
//  ShoppingTests
//
//  Created by Tobias Baube on 11.06.17.
//  Copyright © 2017 Tobias Baube. All rights reserved.
//

import XCTest
@testable import Shopping

class CurrencyDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Could go further and test for all different invalid json types, with missing attributes
    // Like to use JSON Fuzz for this purpose: https://github.com/deme0607/json-fuzz-generator
    // Easily to customize with own attributes, nonetheless, as we use the new codable available from Xcode 9.0, we do not have to unit test all these properties anymore (at least for JSON)
    func testExchangeRateFromUSD() {
        let currencyModelSerializer = CurrencyModelSerializer()
        let jsonUnitTestFilesPrefix = "currencyDataJSON_valid"
        
        do {
            let bundleRoot = Bundle(for: type(of: self)).bundlePath
            let dirContents = try FileManager.default.contentsOfDirectory(atPath: bundleRoot)
            let testFiles = dirContents.filter { $0.hasPrefix(jsonUnitTestFilesPrefix) }
            for file in testFiles {
                let url = URL(fileURLWithPath: file)
                let data = try Data(contentsOf: url)
                
                // test without success block
                currencyModelSerializer.loadCurrency(fromData: data, nil, { (currencyData, error) in
                    XCTAssertTrue(currencyData != nil, "🔴 Expected successful currency data serialization with valid input")
                })
                
                // test with success block
                let expectation = self.expectation(description: "Serialization of CurrencyData succeeded")
                currencyModelSerializer.loadCurrency(fromData: data, { (currencyData) in
                    XCTAssertNotNil(currencyData, "🔴 expected currency data to serialize correctly from valid json input")
                    expectation.fulfill()
                }, { (currencyData, error) in
                    XCTAssertTrue(currencyData != nil, "🔴 Expected successful currency data serialization with valid input")
                })
                
                waitForExpectations(timeout: 3.0, handler:nil)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
//            NSString *bundleRoot = [[NSBundle bundleForClass:[MCLTestHelperfunctions class]] bundlePath];
//            NSFileManager *fm = [NSFileManager defaultManager];
//            NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
//            // Get the directory contents urls (including subfolders urls)
//            let fltr = NSPredicate(format: "self BEGINSWITH %@", beginWith)
//            // if you want to filter the directory contents you can do like this:
//            //let mp3Files = directoryContents.
            
            
//
//            NSArray *fileNames = [dirContents filteredArrayUsingPredicate:fltr];
//            return fileNames;
        
        
        
//        // Get the document directory url
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        do {
//            print(directoryContents)
//
//            // if you want to filter the directory contents you can do like this:
//            let mp3Files = directoryContents.filter{ $0. == "mp3" }
//            print("mp3 urls:",mp3Files)
//            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
//            print("mp3 list:", mp3FileNames)
//
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
        
        
    }
}
