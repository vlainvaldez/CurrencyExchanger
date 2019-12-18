//
//  BalanceVC.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/18/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public class BalanceVC: UIViewController {
    
    // MARK: - Initializer
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinitializer
    deinit {
        print("\(type(of: self)) was deallocated")
    }
    
    // MARK: - Life Cycle Methods
    public override func loadView() {
        super.loadView()
        
        self.view = BalanceView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.cellsRegistration()
        self.balanceCollectionView.dataSource = self
        self.balanceCollectionView.delegate = self
    }

}

// MARK: - Views
extension BalanceVC {
    public var rootView: BalanceView { return self.view as! BalanceView }
    public var balanceCollectionView: UICollectionView { return self.rootView.collectionView }
}

// MARK: - Helper Methods
extension BalanceVC {
    private func cellsRegistration() {
        self.balanceCollectionView.register(
            BalanceItemRow.self,
            forCellWithReuseIdentifier: BalanceItemRow.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource Methods
extension BalanceVC: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BalanceItemRow.identifier,
                for: indexPath
            ) as? BalanceItemRow
        else { return UICollectionViewCell() }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension BalanceVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.rootView.frame.width / 3 , height: self.rootView.frame.height)
    }
}
