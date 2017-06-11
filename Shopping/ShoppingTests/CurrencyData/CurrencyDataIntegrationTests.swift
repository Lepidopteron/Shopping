//
//  CurrencyDataTests.swift
//  ShoppingTests
//
//  Created by Tobias Baube on 11.06.17.
//  Copyright © 2017 Tobias Baube. All rights reserved.
//

import XCTest
@testable import Shopping

class CurrencyDataIntegrationTests: XCTestCase {
    
    func testLoadDataFromAPI_Valid() {
        let currencyModelSerializer = CurrencyModelSerializer()
        let urlString = "http://www.apilayer.net/api/live?access_key=3afe856274d76909c7efa6e537e00640&source=USD"
        let expect = self.expectation(description: "Serialization of CurrencyData succeeded")
        currencyModelSerializer.loadCurrencyFromURL(fromUrl: urlString, { (currencyData) in
            expect.fulfill()
        }) { (currencyData, error) in
            XCTFail("Expected successful data fetching from backend source")
        }
        waitForExpectations(timeout: 2.0, handler:nil)
    }
    
    func testLoadDataFromAPI_Invalid() {
        let currencyModelSerializer = CurrencyModelSerializer()
        let urlString = "https://www.google.com"
        let expect = self.expectation(description: "Serialization of CurrencyData failed")
        currencyModelSerializer.loadCurrencyFromURL(fromUrl: urlString, { (currencyData) in
            XCTFail("Expected invalid data fetching from backend source")
        }) { (currencyData, error) in
            XCTAssertNil(currencyData)
            XCTAssertNotNil(error, "Expected general web request error")
            expect.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler:nil)
    }
    
    func testLoadDataFromAPIURLFromCurrencyModel_Valid() {
        let currencyModelSerializer = CurrencyModelSerializer()
        let urlString = CurrencyData.apiUrlForCurrency(.USD)
        let expect = self.expectation(description: "Serialization of CurrencyData succeeded")
        currencyModelSerializer.loadCurrencyFromURL(fromUrl: urlString, { (currencyData) in
            expect.fulfill()
        }) { (currencyData, error) in
            XCTFail("Expected successful data fetching from backend source")
        }
        waitForExpectations(timeout: 2.0, handler:nil)
    }
    
    func testLoadDataFromAPIURLFromCurrencyModel_Invalid() {
        let currencyModelSerializer = CurrencyModelSerializer()
        let urlString = CurrencyData.apiUrlForCurrency(.GBP) // only have "light" subscription, thus it should fail with an error from their backend
        let expect = self.expectation(description: "Serialization of CurrencyData failed")
        currencyModelSerializer.loadCurrencyFromURL(fromUrl: urlString, { (currencyData) in
            XCTFail("Expected invalid data fetching from backend source")
        }) { (currencyData, error) in
            XCTAssertNotNil(currencyData?.error, "Expected an error from their backend")
            XCTAssertNil(error)
            expect.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler:nil)
    }
}
