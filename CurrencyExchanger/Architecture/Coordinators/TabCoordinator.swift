//
//  TabCoordinator.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/8/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import class UIKit.UIViewController
import class UIKit.UITabBarItem

public protocol TabCoordinator: Coordinator {

    /**
     UIViewController type to be managed by TabCoordinator
    */
    associatedtype ViewController: UIViewController

    /**
     UIViewController instance being managed
    */
    var viewController: ViewController { get }

    /**
     UITabBarItem for the UIViewController
    */
    var tabBarItem: UITabBarItem { get }

}
