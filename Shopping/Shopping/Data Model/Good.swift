//
//  Good.swift
//  Shopping
//
//  Created by Tobias Baube on 11.06.17.
//  Copyright © 2017 Tobias Baube. All rights reserved.
//

import Foundation
struct Good {
    public let name: String
    public let price: Double // more accurate, as Float, because e.g. 2.1 is considered as being 2.0999999
    public let unit: String
    public let currency: Currency
}
