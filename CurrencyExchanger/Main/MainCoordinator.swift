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
    private let balanceViewModel: BalanceViewModel = BalanceViewModel()
    
    // MARK: - Instance Methods
    public override func start() {
        super.start()
        
        let balanceCoordiantor: BalanceCoordinator = BalanceCoordinator(balanceModelView: self.balanceViewModel)
        balanceCoordiantor.start()
        let balanceVC = balanceCoordiantor.vc
        self.balanceVC = balanceVC
        let vc: MainVC = MainVC(balanceViewModel: self.balanceViewModel)
        vc.balanceVC = balanceVC
        vc.delegate = self
        self.navigationController.setViewControllers([vc], animated: true)
        self.add(childCoordinator: self)
        self.add(childCoordinator: balanceCoordiantor)
    }
    
    // MARK: - Stored Properties
    private var balanceVC: BalanceVC?
}

// MARK: - MainVCDelegate Methods
extension MainCoordinator: MainVCDelegate {
    
    public func didLoad() {
//        guard let balanceVC = self.balanceVC else { return }
//        balanceVC.rootView.collectionView.reloadData()
    }
    
    public func getCurrency(completion: @escaping (Exchange) -> Void) {
        self.currencyAPIService.getTracks { (exchange: Exchange) -> Void in
            completion(exchange)
        }
    }
}
