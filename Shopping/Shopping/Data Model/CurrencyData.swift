//
//  CurrencyData.swift
//  Shopping
//
//  Created by Tobias Baube on 11.06.17.
//  Copyright © 2017 Tobias Baube. All rights reserved.
//

import Foundation

struct CurrencyData: Codable {
    
    var success: Bool
    var terms: String?
    var privacy: String?
    var timestamp: Int?
    var source: String?
    var quotes: [String: Double]?
    var error: CurrencyDataError?
    
    static func apiUrlForCurrency(_ currency: Currency) -> String {
        return API_CURRENCY_URL+"&source=\(currency)"
    }
    
    /*
     *  If we did not just have the free version, we could use the following API request instead:
     *  http://apilayer.net/api/convert?access_key=3afe856274d76909c7efa6e537e00640&from=USD&to=GBP&amount=10&format=1
     */
    func exchangeRate(from fromCurrency: Currency, to toCurrency: Currency) -> Double {
        var exchangeRate = 1.0
        
        // As we got only the "light" version of currencylayer, we have to convert to "fromCurrency" to USD and then convert this to "toCurrency"
        let rateToUSD = exchangeRateFromUSD(to: fromCurrency)
        let rateFromUSD = exchangeRateFromUSD(to: toCurrency)
        
        if rateToUSD != 0 && rateFromUSD != 0 {
            exchangeRate = (exchangeRate / rateToUSD) * rateFromUSD
        }
        else {
            return 0.0 // Error, rate should not be zero
        }
//        print("Rate from \(fromCurrency.rawValue) to USD: \(1 / rateToUSD)")
//        print("Rate from USD to \(toCurrency.rawValue): \(rateFromUSD)")
//        print("Rate from \(fromCurrency.rawValue) to \(toCurrency.rawValue): \(exchangeRate)")
        return exchangeRate
    }
    
    /*
     *  Private Helper, as we have only the USD related exchange for the API
     */
    private func exchangeRateFromUSD(to currency: Currency) -> Double {
        guard let _quotes = self.quotes else {
            return 0.0 // Have no quotes
        }
        let baseCurrency = Currency.USD
        // no need to convert FROM USD to USD, if we are already on USD
        if (currency != baseCurrency) {
            let rateFromUSDString = "\(baseCurrency.rawValue)\(currency.rawValue)"
            guard let _exchangeRateFromUSD = _quotes[rateFromUSDString] else {
                return 0.0 // Error, key does not exist
            }
            if _exchangeRateFromUSD != 0 {
                return _exchangeRateFromUSD
            }
            else {
                return 0.0 // Error, rate should not be zero
            }
        }
        return 1.0 // both currencies are equal => exchange rate will be 1.0
    }
}
