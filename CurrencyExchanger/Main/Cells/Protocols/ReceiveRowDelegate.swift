//
//  ReceiveRowDelegate.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/16/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation

public protocol ReceiveRowDelegate: class {
    func receiveChangeCurrency(completion: @escaping (Currency) -> Void )
}
