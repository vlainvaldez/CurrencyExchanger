//
//  UserDefaults+Extensions.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/20/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation

extension UserDefaults {

     var hasLaunchBefore: Bool {
           get {
             return self.bool(forKey: #function)
           }
           set {
             self.set(newValue, forKey: #function)
           }
     }
}
