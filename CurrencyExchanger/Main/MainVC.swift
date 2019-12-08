//
//  MainVC.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/8/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public final class MainVC: UIViewController {
    
    // MARK: Delegate Declarations
    public weak var delegate: MainVCDelegate?
    
    // MARK: - Initializer
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinitializer
    deinit {
        print("\(type(of: self)) was deallocated")
    }
    
    // MARK: - LifeCycle Methods
    public override func loadView() {
        super.loadView()        
        self.view = MainView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency Exchanger"                
    }
}

// MARK: - Views
extension MainVC {
    public var rootView: MainView { return self.view as! MainView }
}
