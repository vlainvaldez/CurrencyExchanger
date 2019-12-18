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
        
        let balanceCoordiantor: BalanceCoordinator = BalanceCoordinator()
        balanceCoordiantor.start()
        let balanceVC = balanceCoordiantor.vc
        
        let vc: MainVC = MainVC()
        vc.balanceVC = balanceVC
        vc.delegate = self
        self.navigationController.setViewControllers([vc], animated: true)
        self.add(childCoordinator: self)
        self.add(childCoordinator: balanceCoordiantor)
    }
    
}

// MARK: - MainVCDelegate Methods
extension MainCoordinator: MainVCDelegate {
    
    public func getCurrency(completion: @escaping (Exchange) -> Void) {
        self.currencyAPIService.getTracks { (exchange: Exchange) -> Void in
            completion(exchange)
        }
    }
}
