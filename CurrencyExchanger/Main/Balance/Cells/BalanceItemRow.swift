//
//  BalanceItemRow.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/18/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import SnapKit

public class BalanceItemRow: UICollectionViewCell {
    
    // MARK: - Subviews
    
    public lazy var currencyLabel: UILabel = {
        let view: UILabel = UILabel()
        view.textColor = UIColor.white
        view.text = "$"
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
        return view
    }()
    
    public lazy var amountLabel: UILabel = {
        let view: UILabel = UILabel()
        view.textColor = UIColor.white
        view.text = "100,0000000000000000"
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
        view.sizeToFit()
        return view
    }()
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.subviews(forAutoLayout: [
            self.currencyLabel, self.amountLabel
        ])
        
        self.currencyLabel.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(20.0)
            make.centerX.equalToSuperview()
        }
        
        self.amountLabel.snp.remakeConstraints { [unowned self](make: ConstraintMaker) -> Void in
            make.top.equalTo(self.currencyLabel.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().offset(5.0)
            make.trailing.equalToSuperview().inset(5.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Public APIs
extension BalanceItemRow {
    public static var identifier: String = "BalanceItemRow"
    
    public func configure(with balanceData: BalanceData) {
        self.currencyLabel.text = balanceData.currency
        self.amountLabel.text = "\(balanceData.value)"
    }
}

