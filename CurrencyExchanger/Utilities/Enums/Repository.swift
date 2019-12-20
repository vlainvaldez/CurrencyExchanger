//
//  Repository.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/20/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation

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
    
    func saveBalance(
        balances: [BalanceData],
        _ completion: @escaping ((Result<Bool, Error>) -> Void )) {

        do {
            try self.database.save(balances: balances)
            completion(.success(true))
        } catch {
            completion(.success(false))
        }
    }
    
}
