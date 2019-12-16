//
//  ReceiveRow.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/13/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

public class ReceiveRow: UICollectionViewCell {
    
    // MARK: - Delegate Declarations
    public weak var delegate: ReceiveRowDelegate?
    
    // MARK: - Subviews
    public var amountTextField: TextField = {
        let view: TextField = TextField()
        view.borderStyle = .none
        view.autocapitalizationType = UITextAutocapitalizationType.none
        view.autocorrectionType = UITextAutocorrectionType.no
        view.backgroundColor = UIColor.white
        view.keyboardType = .numberPad
        view.isEnabled = false
        return view
    }()
    
    public let currencyButton: UIButton = {
        let view: UIButton = UIButton()
        view.setTitle("EUR", for: UIControl.State.normal)
        view.setTitleColor(
            UIColor.white,
            for: UIControl.State.normal
        )
        view.titleLabel?.font = UIFont.systemFont(
            ofSize: 15.0,
            weight: UIFont.Weight.bold
        )
        view.accessibilityIdentifier = "saveButton_UIButton"
        return view
    }()
    
    public lazy var receiveLabel: UILabel = {
        let view: UILabel = UILabel()
        view.textColor = UIColor.white
        view.text = "Receive"
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
        return view
    }()
    
    // MARK: - Stored Properties
    public var currency: Currency? {
        didSet{
            print("\(currency!.symbol) \(currency!.rate)")
        }
    }
    private var viewModel: ReceiveRowViewModel?
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.subviews(forAutoLayout: [
            self.receiveLabel, self.amountTextField,
            self.currencyButton
        ])
        
        self.receiveLabel.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10.0)
            make.width.equalTo(80.0)
        }

        self.amountTextField.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(30.0)
            make.leading.equalTo(self.receiveLabel.snp.trailing).offset(5.0)
            make.trailing.equalTo(self.currencyButton.snp.leading)
            make.bottom.equalToSuperview().inset(30.0)
        }
        
        self.currencyButton.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(30.0)
            make.width.equalTo(80.0)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(30.0)
        }
        
        self.setTargetActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.amountTextField.setRadius(radius: 10.0)
    }
}

// MARK: - Public APIs
extension ReceiveRow {
    public static var identifier: String = "ReceiveRow"
    
    public func configure(with viewModel: ReceiveRowViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Helper Methods
extension ReceiveRow {
    
    private func setTargetActions() {
        self.currencyButton.addTarget(
            self,
            action: #selector(ReceiveRow.currecyButtonTapped),
            for: UIControl.Event.touchUpInside
        )
    }
}

// MARK: - Target Action Methods
extension ReceiveRow {
    
    @objc func currecyButtonTapped(_ sender: UIButton) {
        self.delegate?.receiveChangeCurrency(completion: { [weak self] (currency: Currency) -> Void in
            guard
                let self = self,
                let viewModel = self.viewModel
            else { return }
            self.currency = currency
            self.currencyButton.setTitle(currency.symbol, for: UIControl.State.normal)
            viewModel.input.currency.onNext(currency)
        })
    }
}
