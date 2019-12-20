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
    public var balance: PublishSubject<[BalanceData]> = PublishSubject<[BalanceData]>()
}
