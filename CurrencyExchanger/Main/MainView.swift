//
//  MainView.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/8/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import SnapKit

public class MainView: UIView {
    
    // MARK: - Delegate Declaration
    public weak var delegate: MainViewDelegate?
    
    // MARK: - Subviews
    public var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        let view: UICollectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        view.showsVerticalScrollIndicator = false
        view.allowsMultipleSelection = false
        view.isScrollEnabled = true
        view.bounces = true
        view.backgroundColor = AppUI.Color.sky
        return view
    }()
    
    public let sellCurrencyPicker: UIPickerView = {
        let view: UIPickerView = UIPickerView()
        view.tag = 0
        view.frame = CGRect(x: 5, y: 20, width: 250, height: 140)
        return view
    }()
    
    public let receiveCurrencyPicker: UIPickerView = {
        let view: UIPickerView = UIPickerView()
        view.tag = 1
        view.frame = CGRect(x: 5, y: 20, width: 250, height: 140)
        return view
    }()
    
    // MARK: - Stored Properties
    private var keyboardManager: KeyboardManager?
    private var collectionViewBottomConstraint: Constraint!
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)        
        self.backgroundColor = UIColor.white
        
        self.keyboardManager = KeyboardManager(scrollView: self.collectionView)
        self.keyboardManager?.beginObservingKeyboard()
        self.keyboardManager?.delegate = self
        
        self.subviews(forAutoLayout: [
            self.collectionView
        ])
        
        self.collectionView.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) -> Void in
            make.top.leading.trailing.equalToSuperview()
            self.collectionViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinitializer
    deinit {
        self.keyboardManager?.endObservingKeyboard()
        print("\(type(of: self)) was deallocated")
    }
}

// MARK: - KeyboardManagerDelegate Methods
extension MainView: KeyboardManagerDelegate {
    
    public func kmDidShow(height: CGFloat) {
        self.delegate?.keyBoardShown()
    }
    
    public func kmDidHide() {
        self.delegate?.keyBoardHidden()
    }
    
}
