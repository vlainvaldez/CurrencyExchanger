//
//  Database.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/20/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import RealmSwift

public final class Database {
    
    enum DatabaseError: Error {
        case savingError
        case fetchingError
    }
    
    
    func save(balances: [BalanceData]) throws {
        
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
        } catch  {
            throw DatabaseError.savingError
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
    
}
