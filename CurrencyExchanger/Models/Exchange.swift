//
//  Exchange.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/14/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation

public struct Exchange: Decodable {
    public let rates : [String: Double]
    public let base: String
    public let date: String
}
