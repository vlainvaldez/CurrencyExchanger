//
//  SellRowViewModel.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/16/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class SellRowViewModel: InputOutputViewModel {
    
    let input: Input
    var output: Output
    
    public struct Input {
        let amount: AnyObserver<String>
        let currencySubject = PublishSubject<Currency>()
    }
    
    public struct Output {
        let amount: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        var currency: Currency = Currency(symbol: "EUR", rate: 0.0)
    }
    
    private let amountSubject = PublishSubject<String>()
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Initializer
    public init() {
        
        self.output = Output()
        
        self.amountSubject.bind(to: self.output.amount).disposed(by: self.disposeBag)
        self.input = Input(amount: self.amountSubject.asObserver())
        
        self.input.currencySubject.subscribe(onNext: { [weak self] (currency: Currency) in
            guard let self = self else { return }
            self.output.currency = currency
        }).disposed(by: self.disposeBag)
        
    }
}
