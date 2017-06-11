//
//  CurrencyModelRequester.swift
//  Shopping
//
//  Created by Tobias Baube on 11.06.17.
//  Copyright © 2017 Tobias Baube. All rights reserved.
//

import Foundation

class CurrencyModelSerializer {
    let urlString = CurrencyData.apiUrlForCurrency(.USD)
    var currencyData: CurrencyData?
    
    func loadCurrencyFromURL(fromUrl urlString: String, _ success: ((CurrencyData) -> Swift.Void)?, _ failure: ((CurrencyData?, Error?) -> Swift.Void)?) {
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let _error = error {
                if let _failure = failure {
                    _failure(nil, _error)
                }
                return
            }
            self.loadCurrency(fromData: data, success, failure)
        }
        task.resume()
    }
    
    func loadCurrency(fromData data: Data?, _ success: ((CurrencyData) -> Swift.Void)?, _ failure: ((CurrencyData?, Error?) -> Swift.Void)?) {
        guard let _data = data else {
            // could initialize a custom error object here.
            // As we already call failure here, we will pass for reasons of the 2hrs time, just nil. In real projects we would have a related error information
            if let _failure = failure {
                _failure(nil, nil)
            }
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            let _currencyData = try decoder.decode(CurrencyData.self, from: _data)
            if _currencyData.success {
                guard let _quotes = _currencyData.quotes else {
                    if let _failure = failure {
                        _failure(nil, nil)
                    }
                    return
                }
                print(_quotes)
                if let _success = success {
                    _success(_currencyData)
                }
                //_currencyData.exchangeRate(from: .GBP, to: .EUR)
            }
            else {
                guard let _error = _currencyData.error else {
                    return
                }
                print(_error)
                if let _failure = failure {
                    _failure(_currencyData, nil)
                }
            }
            self.currencyData = _currencyData
        }
        catch {
            print("error converting data to JSON: \(error)")
            if let _failure = failure {
                _failure(nil, error)
            }
        }
    }
}
