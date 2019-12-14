//
//  Currency.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/14/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation

public class Currency: NSObject {
    
    // MARK: - Initializer
    public init(symbol: String, rate: Double) {
        self.symbol = symbol
        self.rate = rate
        super.init()
    }
    
    // MARK: - Stored Properties
    public let symbol: String
    public let rate: Double
}
