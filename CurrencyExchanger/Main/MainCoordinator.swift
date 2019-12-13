//
//  MainCoordinator.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/8/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public final class MainCoordinator: AbstractCoordinator {
    
    // MARK: - Initializer
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    // MARK: - Stored Properties
    private let navigationController: UINavigationController
    private let currencyAPIService: CurrencyAPIService = CurrencyAPIService()
    // MARK: - Instance Methods
    public override func start() {
        super.start()
                
        self.currencyAPIService.getTracks { (currency: Currency) -> Void in            
            print(currency.rates)
        }
        
        let vc: MainVC = MainVC()
        
        self.navigationController.setViewControllers([vc], animated: true)
        self.add(childCoordinator: self)
    }
    
}
