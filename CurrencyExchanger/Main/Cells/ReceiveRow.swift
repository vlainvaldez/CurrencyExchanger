//
//  ReceiveRow.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/13/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public class ReceiveRow: UICollectionViewCell {
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public APIs
extension ReceiveRow {
    public static var identifier: String = "ReceiveRow"
}
