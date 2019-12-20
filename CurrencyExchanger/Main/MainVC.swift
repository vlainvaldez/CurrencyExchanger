//
//  MainVC.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/8/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import PKHUD
import RxCocoa
import RxSwift

public final class MainVC: UIViewController {
    
    // MARK: Delegate Declarations
    public weak var delegate: MainVCDelegate?
    
    // MARK: - Initializer
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinitializer
    deinit {
        print("\(type(of: self)) was deallocated")
        self.disposeBag = nil
    }
    
    // MARK: - LifeCycle Methods
    public override func loadView() {
        super.loadView()        
        self.view = MainView()
        self.rootView.collectionView.dataSource = self
        self.rootView.collectionView.delegate = self
        self.cellRegistration()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency Exchanger"
        self.setCurrencyPicker()        
        self.fetchCurrency()
        self.checkLaunchedBefore()
        
        if let balanceVC = self.balanceVC {
            self.addChildContentViewController(balanceVC)
        }
    }
    
    // MARK: - Stored Properties
    private var exchangeCurrencies: [Currency] = [Currency]()
    private var exchange: Exchange?
    private var sellCurrency: Currency?
    private var receiveCurrency: Currency?
    private var sellRowViewModel: SellRowViewModel = SellRowViewModel()
    private var receiveRowViewModel: ReceiveRowViewModel = ReceiveRowViewModel()
    private var disposeBag: DisposeBag!
    public weak var balanceVC: BalanceVC?
    private let repository: Repository = Repository(database: Database())
}

// MARK: - UICollectionViewDataSource Methods
extension MainVC: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainRows.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let row = MainRows(rawValue: indexPath.item) else { return UICollectionViewCell() }
        
        switch row {
        case .balanceRow:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BalancesRow.identifier,
                    for: indexPath
                ) as? BalancesRow,
                let balanceVC = self.balanceVC
            else { return UICollectionViewCell() }
            
            cell.hostedView = balanceVC.rootView
            return cell
            
        case .sellRow:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SellRow.identifier,
                    for: indexPath
                ) as? SellRow
            
            else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configure(with: self.sellRowViewModel)
            return cell
            
        case .receiveRow:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ReceiveRow.identifier,
                    for: indexPath
                ) as? ReceiveRow
            
            else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configure(with: self.receiveRowViewModel)
            return cell
            
        case .submitRow:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SubmitRow.identifier,
                    for: indexPath
                ) as? SubmitRow
            
            else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension MainVC: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.rootView.frame.width, height: 100.0)
    }
    
}

// MARK: - Views
extension MainVC {
    public var rootView: MainView { return self.view as! MainView }
}

// MARK: - Helper Methods
extension MainVC {
    
    private func cellRegistration() {
        
        self.rootView.collectionView.register(BalancesRow.self, forCellWithReuseIdentifier: BalancesRow.identifier)
        self.rootView.collectionView.register(ReceiveRow.self, forCellWithReuseIdentifier: ReceiveRow.identifier)
        self.rootView.collectionView.register(SellRow.self, forCellWithReuseIdentifier: SellRow.identifier)
        self.rootView.collectionView.register(SubmitRow.self, forCellWithReuseIdentifier: SubmitRow.identifier)
    }
    
    private func setCurrencyPicker() {
        self.rootView.sellCurrencyPicker.dataSource = self
        self.rootView.sellCurrencyPicker.delegate = self
        self.rootView.receiveCurrencyPicker.dataSource = self
        self.rootView.receiveCurrencyPicker.delegate = self
    }
    
    private func setPickerValues(currencies: [Currency] ) {        
        self.exchangeCurrencies = currencies
        self.rootView.sellCurrencyPicker.reloadAllComponents()
        self.rootView.receiveCurrencyPicker.reloadAllComponents()
    }
    
    // MARK: - ChildViewControllers
    private func addChildContentViewController(_ childViewController: UIViewController) {
        self.addChild(childViewController)
        childViewController.didMove(toParent: self)
    }
    
    func saveCurrencies(_ currencies: [Currency]) {
        let balanceData: [BalanceData] = currencies.map{ BalanceData(currency: $0.symbol, value: 0.0) }
        HUD.show(HUDContentType.progress)
        self.repository.saveBalance(balances: balanceData) { (result: Result<Bool, Error>) in
            switch result {
            case .success:
                HUD.hide()
            case .failure:
                HUD.flash(HUDContentType.error)
            }
        }
    }
    
    private func checkLaunchedBefore() {
        if !UserDefaults.standard.hasLaunchBefore  {
            let balanceData: BalanceData = BalanceData(currency: "EUR", value: 1000)
            HUD.show(HUDContentType.progress)
            self.repository.saveBalance(balances: [balanceData]) { (result: Result<Bool, Error>) -> Void in
                switch result {
                case .success:
                    HUD.hide()
                    self.rootView.collectionView.reloadData()
                case .failure:
                    HUD.flash(HUDContentType.error)
                }
            }
            UserDefaults.standard.hasLaunchBefore = true
        }
    }
}

// MARK: - SellRowDelegate Methods
extension MainVC: SellRowDelegate {
    public func sellChangeCurrency(completion: @escaping (Currency) -> Void) {
        
        let alert = UIAlertController(
            title: "Currencies Choices",
            message: "\n\n\n\n\n\n",
            preferredStyle: .alert
        )
        
        alert.view.addSubview(self.rootView.sellCurrencyPicker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] (alertAction: UIAlertAction) -> Void in
            guard
                let self = self,
                let currency = self.sellCurrency
            else { return }            
            completion(currency)
        })
        
        self.present(alert,animated: true, completion: nil )
    }
    
}

// MARK: - SellRowDelegate Methods
extension MainVC: ReceiveRowDelegate {
    public func receiveChangeCurrency(completion: @escaping (Currency) -> Void) {
        
        let alert = UIAlertController(
            title: "Currencies Choices",
            message: "\n\n\n\n\n\n",
            preferredStyle: .alert
        )
        
        alert.view.addSubview(self.rootView.receiveCurrencyPicker)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] (alertAction: UIAlertAction) -> Void in
            guard
                let self = self,
                let currency = self.receiveCurrency
            else { return }
            completion(currency)
        })
        
        self.present(alert,animated: true, completion: nil )
    }
}

// MARK: - SubmitRowDelegate Methods
extension MainVC: SubmitRowDelegate {
    public func submitTapped() {
        
        guard
            let receiveCurrency = self.receiveRowViewModel.output.currency
        else { return }

        let computation = Double(self.sellRowViewModel.output.amount.value)! * Double(receiveCurrency.rate)
        let computationWithCommission = computation - 0.70
        let roundedValue = computationWithCommission.roundTo(places: 2)
        
        print("value: \(computation)")
        print("value with commision: \(computationWithCommission)")
        print("Rounded Value: \(roundedValue)")
    }
}

// MARK: - Network API Access
extension MainVC {
    
    private func fetchCurrency() {
        HUD.show(HUDContentType.progress)
        self.delegate?.getCurrency { [weak self] (exchange: Exchange) -> Void in
            guard let self = self else { return }
            HUD.hide()
            self.exchange = exchange
            let currencies = exchange.rates
                .map { Currency(symbol: $0.key, rate: $0.value) }
                .sorted(
                    by: { (currency1: Currency, currency2: Currency) -> Bool in
                        return currency1.symbol.lowercased() < currency2.symbol.lowercased()
                    }
                )

            self.setPickerValues(currencies: currencies)
            self.saveCurrencies(currencies)
        }
    }
    
}

// MARK: - UIPickerViewDataSource Methods
extension MainVC: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.exchangeCurrencies.count
    }
}

// MARK: - UIPickerViewDelegate Methods
extension MainVC: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.exchangeCurrencies[row].symbol
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let pickerType = PickerType(rawValue: pickerView.tag)
        
        switch pickerType {
        case .sell:
            self.sellCurrency = self.exchangeCurrencies[row]
        case .receive:
            self.receiveCurrency = self.exchangeCurrencies[row]
        case .none:
            break
        }
    }
}
