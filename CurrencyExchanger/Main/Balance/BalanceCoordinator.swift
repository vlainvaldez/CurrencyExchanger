//
//  BalanceCoordinator.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/18/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public final class BalanceCoordinator: AbstractCoordinator {
    
    // MARK: - Initializer
    public override init() {
        super.init()
    }
    
    // MARK: - Stored Properties
    public var vc: BalanceVC!
    
    // MARK: - Instance Methods
    public override func start() {
        super.start()
        let vc: BalanceVC = BalanceVC()
        self.vc = vc
        
        self.add(childCoordinator: self)
    }
    
}
