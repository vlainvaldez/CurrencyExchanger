//
//  AppMainCoordinator.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/8/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

open class AppMainCoordinator: AbstractCoordinator {
    
    // MARK: Initializer
    public init(window: UIWindow, rootViewController: UINavigationController) {
        self.window = window
        self.rootViewController = rootViewController
        super.init()
        
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
        
    }
    
    // MARK: Stored Properties
    private unowned let rootViewController: UINavigationController
    private unowned let window: UIWindow
    
    // MARK: Instance Methods
    public override func start() {
        super.start()
    
        let coordinator: MainCoordinator = MainCoordinator(
            navigationController: self.rootViewController
        )
        
        coordinator.start()
        self.add(childCoordinator: self)        
    }
}
