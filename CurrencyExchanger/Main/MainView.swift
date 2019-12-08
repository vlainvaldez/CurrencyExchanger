//
//  MainView.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/8/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public class MainView: UIView {
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)        
        self.backgroundColor = UIColor.white
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinitializer
    deinit {
        print("\(type(of: self)) was deallocated")
    }
}
