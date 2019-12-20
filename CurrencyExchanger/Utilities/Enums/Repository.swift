//
//  Repository.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/20/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public final class Repository {
    
    // MARK: - Initializer
    public init(database: Database) {
        self.database = database
    }
    
    // MARK: - Stored Properties
    private let database: Database!
    
    func getBalances( _ completion: @escaping ((Result<[BalanceData], Error>) -> Void )) {
        
        do {
            try completion(.success(self.database.get()))
        } catch {
            completion(.failure(Database.DatabaseError.fetchingError ))
        }
    }
    
    func getBalances() -> Single<[BalanceData]> {
        let disposable = Disposables.create()
        
        return Single<[BalanceData]>.create { (single: @escaping (SingleEvent<[BalanceData]>) -> Void) -> Disposable in
            do {
                try single(.success(self.database.get()))
            } catch {
                single(.error(Database.DatabaseError.fetchingError ))
            }
        
            return disposable
        }
    }
    
    func getObservableBalances() -> Observable<BalanceData> {
        let balanceData = self.database.getObservableObjects().map { (balance: Balance) -> BalanceData in
            return BalanceData(currency: balance.currency, value: balance.value)
        }
        return balanceData
    }
    
    func getBalance(with currency: Currency) -> Single<BalanceData> {
        let disposable = Disposables.create()
        
        return Single<BalanceData>.create { (single: @escaping (SingleEvent<BalanceData>) -> Void) -> Disposable in
            do {
                try single(.success(self.database.get(with: currency.symbol)))
            } catch {
                single(.error(Database.DatabaseError.fetchingError ))
            }            
            return disposable
        }
    }
        
    
    func getBalance(with currency: Currency, _ completion: @escaping ((Result<BalanceData, Error>) -> Void )) {
        do {
            try completion(.success(self.database.get(with: currency.symbol)))
        } catch {
            completion(.failure(Database.DatabaseError.fetchingError ))
        }
    }
    
    func saveBalance(balances: [BalanceData]) -> Single<Void> {
        let disposable = Disposables.create()
        return Single<Void>.create { (single: @escaping (SingleEvent<()>) -> Void) -> Disposable in
            self.database.save(balances: balances) { (result: Result<Bool, Error>) -> Void in
                switch result {
                case .success:
                    single(.success(()))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return disposable
        }
    }
    
    func saveBalance(balances: [BalanceData]) -> Single<[BalanceData]> {
        let disposable = Disposables.create()
        return Single<[BalanceData]>.create { (single: @escaping (SingleEvent<[BalanceData]>) -> Void) -> Disposable in
            self.database.save(balances: balances) { (result: Result<Bool, Error>) -> Void in
                switch result {
                case .success:
                    do {
                        try single(.success(self.database.get()))
                    } catch {
                        single(.error(Database.DatabaseError.fetchingError ))
                    }
                case .failure(let error):
                    single(.error(error))
                }
            }
            return disposable
        }
    }
    
    func saveBalance(
        balances: [BalanceData],
        _ completion: @escaping ((Result<Bool, Error>) -> Void )) {
        self.database.save(balances: balances) { (result: Result<Bool, Error>) -> Void in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
