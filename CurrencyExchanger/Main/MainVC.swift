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
        self.rootView.collectionView.dataSource = self
        self.rootView.collectionView.delegate = self
        self.cellRegistration()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency Exchanger"
        self.setCurrencyPicker()
    }
    
    // MARK: - Stored Properties
    private let currencies: [String] = ["EUR", "USD", "SGD"]
}

// MARK: - UICollectionViewDataSource Methods
extension MainVC: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainRows.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let row = MainRows(rawValue: indexPath.item) else { return UICollectionViewCell() }
        
        switch row {
        case .balanceRow:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BalancesRow.identifier,
                    for: indexPath
                ) as? BalancesRow
            
            else { return UICollectionViewCell() }
            return cell
            
        case .sellRow:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SellRow.identifier,
                    for: indexPath
                ) as? SellRow
            
            else { return UICollectionViewCell() }
            
            cell.delegate = self
            
            return cell
            
        case .receiveRow:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ReceiveRow.identifier,
                    for: indexPath
                ) as? ReceiveRow
            
            else { return UICollectionViewCell() }
            return cell
            
        case .submitRow:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SubmitRow.identifier,
                    for: indexPath
                ) as? SubmitRow
            
            else { return UICollectionViewCell() }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension MainVC: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.rootView.frame.width, height: 100.0)
    }
    
}

// MARK: - Views
extension MainVC {
    public var rootView: MainView { return self.view as! MainView }
}

// MARK: - Helper Methods
extension MainVC {
    
    private func cellRegistration() {
        
        self.rootView.collectionView.register(BalancesRow.self, forCellWithReuseIdentifier: BalancesRow.identifier)
        self.rootView.collectionView.register(ReceiveRow.self, forCellWithReuseIdentifier: ReceiveRow.identifier)
        self.rootView.collectionView.register(SellRow.self, forCellWithReuseIdentifier: SellRow.identifier)
        self.rootView.collectionView.register(SubmitRow.self, forCellWithReuseIdentifier: SubmitRow.identifier)
    }
    
    private func setCurrencyPicker() {
        self.rootView.currencyPicker.dataSource = self
        self.rootView.currencyPicker.delegate = self        
    }
    
}

// MARK: - SellRowDelegate Methods
extension MainVC: SellRowDelegate {
    public func sellChangeCurrency(completion: @escaping (Int) -> Void) {
        
        let alert = UIAlertController(title: "Car Choices", message: "\n\n\n\n\n\n", preferredStyle: .alert)

        
        self.rootView.currencyPicker.frame = CGRect(x: 5, y: 20, width: 250, height: 140)
        
        alert.view.addSubview(self.rootView.currencyPicker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            completion(2)
        }))
        
        self.present(alert,animated: true, completion: nil )

    }   
}

// MARK: - UIPickerViewDataSource Methods
extension MainVC: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currencies.count
    }
}

// MARK: - UIPickerViewDelegate Methods
extension MainVC: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currencies[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row \(row) tag \(pickerView.tag)")
    }
}
