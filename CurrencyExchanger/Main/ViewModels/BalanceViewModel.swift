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
    public var commission: Double = 0.70
    deinit {
        self.disposeBag = nil
    }
}

// MARK: - Public APIs
extension BalanceViewModel {
    
    public func saveDefaultBalance(with value: Double = 1000.00) {
        let balanceData: BalanceData = BalanceData(currency: "EUR", value: value)
        self.repository.saveBalance([balanceData]).subscribe().disposed(by: self.disposeBag)
    }
    
    public func saveCurrencies(_ balanceData: [BalanceData]) {
        self.repository.saveBalance(balances: balanceData)
        .subscribe(onSuccess: { [weak self] (balanceData: [BalanceData]) -> Void in
            guard let self = self else { return }
            self.balance.onNext(balanceData)
        }).disposed(by: self.disposeBag)
    }
    
    /// Save Converted Currency to the Local Database using RxSwift
    /// - Parameter convertedValue: Value after Convertion to Other "Currency"
    /// - Parameter initialAmountValue: Value before Convertion to Other "Currency"
    /// - Parameter beforeCurrency: Currency of the initialAmountValue about to convert
    /// - Parameter afterCurrency: Currency of the Converted value
    public func saveBalance(
        convertedValue: Double,
        initialAmountValue: Double,
        from beforeCurrency: Currency,
        to afterCurrency: Currency) -> Observable<[BalanceData]> {
        
        let saveProcess = self.repository.getBalance(with: beforeCurrency)
        .flatMap { (balanceDatum: BalanceData) -> Single<[BalanceData]> in

            let subtractedCommission: Double = balanceDatum.value - self.commission
            let totalValue = subtractedCommission - initialAmountValue
            
            /*
                balanceDatum.value is less than the value you're about
                to convert, returns error on the subscription(onError)
                if true
             */
            if balanceDatum.value < initialAmountValue {
                return .error(ConvertionError.insuficiencyError)
            }
            
            let newBalance = BalanceData(
                currency: balanceDatum.currency,
                value: totalValue.roundTo(places: 2)
            )
            return self.repository.saveBalance(balances: [newBalance])
            
        }.flatMap { (balanceData: [BalanceData]) -> Single<[BalanceData]> in
                            
            let oldBalanceData = balanceData
                .filter { (balanceData :BalanceData) -> Bool in
                    return balanceData.currency == afterCurrency.symbol
                }.first
            
            let newBalanceDataAmount = oldBalanceData!.value + convertedValue.roundTo(places: 2)
            
            let balanceData = BalanceData(
                currency: afterCurrency.symbol,
                value: newBalanceDataAmount
            )
            
            return self.repository.saveBalance(balances: [balanceData])
            
        }.asObservable().share(replay: 1)
        
        return saveProcess
    }
        
    /// Convertion Computation
    /// - Parameter receiveCurrency: Currency about to convert
    /// - Parameter amountToConvert: Amount being converted
    /// - Returns: Double: Rounded value after convertion
    public func computeConvertion(
        receiveCurrency: Currency,
        amountToConvert amount: Double,
        debug: Bool = false) -> Double {
        
        let computation = amount * Double(receiveCurrency.rate)
        let computationWithCommission = computation - self.commission
        let finalValue = computationWithCommission.roundTo(places: 2)

        if debug {
            print("value: \(computation)")
            print("value with commision: \(computationWithCommission)")
            print("Rounded Value: \(finalValue)")
        }

        return finalValue        
    }
    
}


// MARK: - Enumeration Declaration
public enum ConvertionError: Error {
    case insuficiencyError
}

extension ConvertionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .insuficiencyError:
            return NSLocalizedString("Insuficient balance to do Convertion", comment: "Convertion Error")
        }
    }
}
