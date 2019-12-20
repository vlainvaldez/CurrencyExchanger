//
//  BalanceVC.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/18/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import PKHUD

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
        self.updateDataSource()
    }
    
    // MARK: - Stored Properties
    private let repository: Repository = Repository(database: Database())
    private var dataSource: [BalanceData] = [BalanceData]()
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
    
    private func updateDataSource() {
        HUD.show(HUDContentType.progress)
        
        self.repository.getBalances { (result: Result<[BalanceData], Error>) -> Void in
            switch result {
            case .success(let balanceData):
                HUD.hide()
                self.dataSource = balanceData.sorted(
                    by: { (balance1: BalanceData, balance2: BalanceData) -> Bool in
                        return balance1.currency.lowercased() < balance2.currency.lowercased()
                    }
                )

                if let eurCurrencyIndex = self.dataSource.firstIndex(where: { $0.currency == "EUR" }) {
                    self.dataSource = Util.rearrange(
                        array: self.dataSource,
                        fromIndex: eurCurrencyIndex,
                        toIndex: 0
                    )
                }
                
                self.rootView.collectionView.reloadData()
            case .failure(let error):
                HUD.flash(HUDContentType.labeledError(
                    title: nil,
                    subtitle: error.localizedDescription
                ))
            }
        }
    }
}

// MARK: - UICollectionViewDataSource Methods
extension BalanceVC: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BalanceItemRow.identifier,
                for: indexPath
            ) as? BalanceItemRow
        else { return UICollectionViewCell() }
        
        let balanceData = self.dataSource[indexPath.item]
        cell.configure(with: balanceData)
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
