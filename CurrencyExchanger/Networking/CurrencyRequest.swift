//
//  CurrencyRequest.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/13/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//
import Foundation
import Moya

public enum CurrencyRequest {
    case getCurrencies
}


extension CurrencyRequest: TargetType {
    public var baseURL: URL {
        return URL(string: "http://api.exchangeratesapi.io")!
    }

    public var path: String {
        switch self {
        case .getCurrencies:
            return "/latest"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getCurrencies:
            return Moya.Method.get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case .getCurrencies:
          return .requestParameters(parameters: ["access_key" : "API_KEY_HERE_REGISTER_ITS_FREE"], encoding: URLEncoding.default)
        }
    }


    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
        ]
    }

}
