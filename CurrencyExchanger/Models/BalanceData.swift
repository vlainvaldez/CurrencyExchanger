//
//  BalanceData.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/20/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation

public struct BalanceData: Decodable {
    public let currency : String
    public let value: Double
}
