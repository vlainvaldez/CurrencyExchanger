//
//  Balance.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/20/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import RealmSwift

public class Balance: Object {
    @objc dynamic var currency: String = ""
    @objc dynamic var value: Double = 0.0
    
    public override class func primaryKey() -> String? {
        return "currency"
    }
}
