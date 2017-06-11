//
//  CurrencyDataTests.swift
//  ShoppingTests
//
//  Created by Tobias Baube on 11.06.17.
//  Copyright © 2017 Tobias Baube. All rights reserved.
//

import XCTest
@testable import Shopping

class CurrencyDataUnitTests: XCTestCase {
    // Could go further and test for all different invalid json types, with missing attributes
    // Like to use JSON Fuzz for this purpose: https://github.com/deme0607/json-fuzz-generator
    // Easily to customize with own attributes, nonetheless, as we use the new codable available from Xcode 9.0, we do not have to unit test all these properties anymore (at least for JSON)
    func testExchangeRateFromUSD_Valid() {
        let currencyModelSerializer = CurrencyModelSerializer()
        let jsonUnitTestFilesPrefix = "currencyDataJSON_valid"
        
        do {
            let bundleRoot = Bundle(for: type(of: self)).bundlePath
            let dirContents = try FileManager.default.contentsOfDirectory(atPath: bundleRoot)
            let testFiles = dirContents.filter { $0.hasPrefix(jsonUnitTestFilesPrefix) }
            for f in testFiles {
                let file = NSString(string: f)
                let filename = file.deletingPathExtension
                let fileExtension = file.pathExtension
                let filePath = Bundle(for: type(of: self)).path(forResource: filename, ofType: fileExtension)
                let url = URL(fileURLWithPath: filePath!)
                let data = try Data(contentsOf: url)
                
                // test without success block
                currencyModelSerializer.loadCurrency(fromData: data, nil, { (currencyData, error) in
                    XCTAssertTrue(currencyData != nil, "🔴 Expected successful currency data serialization with valid input")
                })
                
                // test with success block
                let expect = self.expectation(description: "Serialization of CurrencyData succeeded")
                currencyModelSerializer.loadCurrency(fromData: data, { (currencyData) in
                    XCTAssertNotNil(currencyData, "🔴 expected currency data to serialize correctly from valid json input")
                    expect.fulfill()
                }, { (currencyData, error) in
                    XCTAssertTrue(currencyData != nil, "🔴 Expected successful currency data serialization with valid input")
                })
                
                waitForExpectations(timeout: 1.0, handler:nil)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
            XCTAssertNotNil(error, "🔴 Expected successful currency data serialization with valid input")
        }
    }
    
    
    func testExchangeRateFromUSD_Invalid() {
        let currencyModelSerializer = CurrencyModelSerializer()
        let jsonUnitTestFilesPrefix = "currencyDataJSON_invalid"
        
        do {
            let bundleRoot = Bundle(for: type(of: self)).bundlePath
            let dirContents = try FileManager.default.contentsOfDirectory(atPath: bundleRoot)
            let testFiles = dirContents.filter { $0.hasPrefix(jsonUnitTestFilesPrefix) }
            for f in testFiles {
                let file = NSString(string: f)
                let filename = file.deletingPathExtension
                let fileExtension = file.pathExtension
                let filePath = Bundle(for: type(of: self)).path(forResource: filename, ofType: fileExtension)
                let url = URL(fileURLWithPath: filePath!)
                let data = try Data(contentsOf: url)
                
                // test without failure block
                currencyModelSerializer.loadCurrency(fromData: data, {(currencyData) in
                    XCTFail("🔴 Successful currency data serialization with invalid input should not pass")
                }, nil)
                
                // test with failure block
                let expect = self.expectation(description: "Serialization of CurrencyData failed")
                currencyModelSerializer.loadCurrency(fromData: data, {(currencyData) in
                    XCTFail("🔴 Successful currency data serialization with invalid input should not pass")
                }, { (currencyData, error) in
                    expect.fulfill()
                })
                waitForExpectations(timeout: 1.0, handler:nil)
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
            XCTAssertNotNil(error, "🔴 Expected successful currency data serialization with valid input")
        }
    }
    
    func testExchangeCalculationValid() {
        do {
            let currencyModelSerializer = CurrencyModelSerializer()
            let filePath = Bundle(for: type(of: self)).path(forResource: "currencyDataJSON_valid", ofType: "json")
            let url = URL(fileURLWithPath: filePath!)
            let data = try Data(contentsOf: url)
            
            // test with success block
            let expect = self.expectation(description: "Serialization of CurrencyData succeeded")
            currencyModelSerializer.loadCurrency(fromData: data, { (currencyData) in
                XCTAssertEqual(currencyData.exchangeRate(from: .USD, to: .USD), 1.0)
                XCTAssertEqual(currencyData.exchangeRate(from: .USD, to: .EUR), 0.893104)
                XCTAssertEqual(currencyData.exchangeRate(from: .GBP, to: .EUR), 1/0.78462 * 0.893104)
                expect.fulfill()
            }, nil)
            
            waitForExpectations(timeout: 1.0, handler:nil)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            XCTAssertNotNil(error, "🔴 Expected successful currency data serialization with valid input")
        }
        
    }
}
