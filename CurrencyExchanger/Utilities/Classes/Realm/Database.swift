//
//  Database.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/20/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

public final class Database {
    
    enum DatabaseError: Error {
        case savingError
        case fetchingError
    }
    
    private var queue = DispatchQueue(label: "database.queue", attributes: .concurrent)
    
    func save(balances: [BalanceData], _ completion: @escaping ((Result<Bool, Error>) -> Void )) {
        do {
            let realm = try Realm()
            try realm.write {
                balances.forEach { (balance: BalanceData) -> Void in
                    let object = Balance()
                    
                    object.currency = balance.currency
                    object.value = balance.value
                    realm.add(object, update: Realm.UpdatePolicy.modified)
                }
            }
            completion(.success(true))
        } catch  {
            completion(.failure(error))
        }
        
    }
    
    func get() throws -> [BalanceData] {        
        do {
            let realm = try Realm()
            
            return realm.objects(Balance.self).map { (balance: Balance) -> BalanceData in
                return BalanceData(currency: balance.currency, value: balance.value)
            }
            
        } catch {
            throw DatabaseError.fetchingError
        }
    }
    
    func getObservableObjects() -> Observable<Balance> {
        do {
            let realm = try Realm()
            
            let balanceObjects = realm.objects(Balance.self)
                
            return Observable.from(balanceObjects)
            
        } catch {
            return Observable.from([Balance]())
        }
    }
    
    func get(with currency: String) throws -> BalanceData {
        do {
            let realm = try Realm()
            
            if let fetchResult = realm.objects(Balance.self).filter("currency = '\(currency)'" ).first {
                return BalanceData(currency: fetchResult.currency, value: fetchResult.value)                
            } else {
                throw DatabaseError.fetchingError
            }
            
        } catch {
            throw DatabaseError.fetchingError
        }
    }

}
