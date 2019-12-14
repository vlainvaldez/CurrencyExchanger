//
//  SellRowDelegate.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/13/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public protocol SellRowDelegate: class {
    func sellChangeCurrency(completion: @escaping (Currency) -> Void )
}

