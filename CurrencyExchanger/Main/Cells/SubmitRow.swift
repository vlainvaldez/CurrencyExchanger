//
//  SubmitRow.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/13/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import SnapKit

public class SubmitRow: UICollectionViewCell {
    
    // MARK: - Delegate Declaration
    public weak var delegate: SubmitRowDelegate?
    
    // MARK: - Subviews
    public let submitButton: UIButton = {
        let view: UIButton = UIButton()
        view.setTitle("Submit", for: UIControl.State.normal)
        view.setTitleColor(
            UIColor.white,
            for: UIControl.State.normal
        )
        view.titleLabel?.font = UIFont.systemFont(
            ofSize: 16.0,
            weight: UIFont.Weight.semibold
        )
        view.accessibilityIdentifier = "saveButton_UIButton"
        view.backgroundColor = AppUI.Color.green
        return view
    }()
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.subviews(forAutoLayout: [
            self.submitButton
        ])
        
        self.submitButton.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
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
        
        self.submitButton.setRadius(radius: 10)
    }
}

// MARK: - Public APIs
extension SubmitRow {
    public static var identifier: String = "SubmitRow"
}

// MARK: - Helper Methods
extension SubmitRow {
    
    private func setUpTargetActions() {
        self.submitButton.addTarget(
            self,
            action: #selector(SubmitRow.submitButtonTapped),
            for: UIControl.Event.touchUpInside
        )
    }
}


// MARK: - Target Action Methods
extension SubmitRow {
    @objc func submitButtonTapped() {
        self.delegate?.submitTapped()
    }
}
