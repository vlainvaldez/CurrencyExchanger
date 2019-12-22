//
//  BalanceViewModel.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/21/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public class BalanceViewModel {
    
    // MARK: - Initializer
    public init() {
        self.disposeBag = DisposeBag()
    }
    
    // MARK: - Stored Properties
    private let repository: Repository = Repository(database: Database())
    public var balance: PublishSubject<[BalanceData]> = PublishSubject<[BalanceData]>()
    private var disposeBag: DisposeBag!
    
    deinit {
        self.disposeBag = nil
    }
}

// MARK: - Public APIs
extension BalanceViewModel {
    public func saveCurrencies(_ balanceData: [BalanceData]) {
        self.repository.saveBalance(balances: balanceData)
        .subscribe(onSuccess: { [weak self] (balanceData: [BalanceData]) -> Void in
            guard let self = self else { return }
            self.balance.onNext(balanceData)
        }).disposed(by: self.disposeBag)
    }
}
