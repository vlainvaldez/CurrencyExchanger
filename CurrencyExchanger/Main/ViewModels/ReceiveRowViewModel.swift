//
//  ReceiveRowViewModel.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/16/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public class ReceiveRowViewModel: InputOutputViewModel {
    
    let input: Input
    var output: Output
    
    public struct Input {
        let currency: AnyObserver<Currency>
        let amount: AnyObserver<String>
    }
    
    public struct Output {
        var amount: Driver<String> = .just("")
        var currency: Currency = Currency(symbol: LocalSymbol.EURO.rawValue, rate: 0.0)
        
    }
    
    private let currencySubject = PublishSubject<Currency>()
    private let amountSubject = PublishSubject<String>()
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Initializer
    public init() {
        self.output = Output()
        self.input = Input(
            currency: self.currencySubject.asObserver(),
            amount: self.amountSubject.asObserver()
        )
        self.disposeBag = DisposeBag()
        
        self.currencySubject.subscribe(onNext: { [weak self] (currency: Currency) in
            guard let self = self else { return }
            self.output.currency = currency
        }).disposed(by: self.disposeBag)
        
        self.output.amount = self.amountSubject.asDriver(onErrorJustReturn: "")
    }
}
