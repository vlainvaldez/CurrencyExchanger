//
//  CurrencyAPIService.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/13/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import Moya

public struct CurrencyAPIService {
    
    // MARK: - Store Properties
    private let provider: MoyaProvider = MoyaProvider<CurrencyRequest>()
    
    public func getTracks(completion: @escaping (Currency) -> Void ) {
        
        self.provider.request(CurrencyRequest.getCurrencies) { (result) in
            switch result {
            case .success(let response):
                
                do{
                    let currency: Currency = try JSONDecoder().decode(
                        Currency.self,
                        from: response.data
                    )
                    completion(currency)
                    
                } catch {
                    print("decoding failed with error: \(error)")
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}
