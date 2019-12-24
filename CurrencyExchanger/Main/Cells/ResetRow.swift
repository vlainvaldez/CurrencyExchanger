//
//  ResetRow.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/24/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import SnapKit

public class ResetRow: UICollectionViewCell {
    
    // MARK: - Delegate Declaration
    public weak var delegate: ResetRowDelegate?
    
    // MARK: - Subviews
    public let clearButton: UIButton = {
        let view: UIButton = UIButton()
        view.setTitle("Clear", for: UIControl.State.normal)
        view.setTitleColor(
            UIColor.white,
            for: UIControl.State.normal
        )
        view.titleLabel?.font = UIFont.systemFont(
            ofSize: 16.0,
            weight: UIFont.Weight.semibold
        )
        view.accessibilityIdentifier = "saveButton_UIButton"
        view.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        return view
    }()
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.subviews(forAutoLayout: [
            self.clearButton
        ])
        
        self.clearButton.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(20.0)
            make.leading.equalToSuperview().offset(50.0)
            make.trailing.equalToSuperview().inset(50.0)
            make.bottom.equalToSuperview().inset(20.0)
        }
        
        self.setUpTargetActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clearButton.setRadius(radius: 10)
    }
}

// MARK: - Public APIs
extension ResetRow {
    public static var identifier: String = "ResetRow"
}

// MARK: - Helper Methods
extension ResetRow {
    
    private func setUpTargetActions() {
        self.clearButton.addTarget(
            self,
            action: #selector(ResetRow.clearButtonTapped),
            for: UIControl.Event.touchUpInside
        )
    }
}

// MARK: - Target Action Methods
extension ResetRow {
    @objc func clearButtonTapped() {
        self.delegate?.clearTapped()
    }
}
