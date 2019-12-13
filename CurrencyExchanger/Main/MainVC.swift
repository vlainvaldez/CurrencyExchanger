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
    }
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
    
}
