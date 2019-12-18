//
//  BalancesRow.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/13/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public class BalancesRow: UICollectionViewCell {
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - HostedView
    var hostedView: UIView? {
        didSet {
            guard let hostedView = hostedView else {
                return
            }
            
            hostedView.frame = contentView.bounds
            contentView.addSubview(hostedView)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        if hostedView?.superview == contentView {
           hostedView?.removeFromSuperview()
        } else {
           print("hostedView is no longer attached to this cell")
        }

        hostedView = nil
    }
}

// MARK: - Public APIs
extension BalancesRow {
    public static var identifier: String = "BalancesRow"
}
