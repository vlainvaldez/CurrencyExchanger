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
    public weak var delegate: MainVCDelegate? {
        didSet{
            print("DELEGATE IS SET")
        }
    }
    
    // MARK: - Initializer
    public init(balanceViewModel: BalanceViewModel) {
        self.balanceViewModel = balanceViewModel
        super.init(nibName: nil, bundle: nil)
        self.disposeBag = DisposeBag()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Deinitializer
    deinit {
        print("\(type(of: self)) was deallocated")
    }
    
    // MARK: - LifeCycle Methods
    public override func loadView() {
        super.loadView()
        let mainView = MainView()
        mainView.delegate = self
        self.view = mainView
        self.rootView.collectionView.dataSource = self
        self.rootView.collectionView.delegate = self
        self.cellRegistration()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency Exchanger"
        
        if let balanceVC = self.balanceVC {
            self.addChildContentViewController(balanceVC)
            self.rootView.collectionView.reloadData()
        }
        
        self.fetchCurrency()
        self.scheduledTimerWithTimeInterval()
        self.setCurrencyPicker()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkLaunchedBefore()
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
    private var balanceViewModel: BalanceViewModel
    private var fetchTimer: Timer?
    private var interval: TimeInterval = 0
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
        
        var currencies = currencies
        let eurCurrency: Currency = Currency(symbol: "EUR", rate: 0.0)
        currencies.append(eurCurrency)
        
        if let eurCurrencyIndex = currencies.firstIndex(where: { $0.symbol == "EUR" }) {
            currencies = Util.rearrange(
                array: currencies,
                fromIndex: eurCurrencyIndex,
                toIndex: 0
            )
        }
        
        self.exchangeCurrencies = currencies
        self.rootView.sellCurrencyPicker.reloadAllComponents()
        self.rootView.receiveCurrencyPicker.reloadAllComponents()
    }
    
    // MARK: - ChildViewControllers
    private func addChildContentViewController(_ childViewController: UIViewController) {
        self.addChild(childViewController)
        childViewController.didMove(toParent: self)
    }
    
    private func removeChildContentViewController(_ childViewController: UIViewController) {
        childViewController.removeFromParent()
        childViewController.willMove(toParent: nil)
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        self.fetchTimer = Timer.scheduledTimer(
            timeInterval: 6, // Added 1 second because the loading indicator take 1 second delay
            target: self,
            selector: #selector(self.fetchCurrency),
            userInfo: nil,
            repeats: true
        )
    }
    
    /// Save Currencies to the Local Database
    /// - Parameter currencies: Array of "Currency" Object
    func saveCurrencies(_ currencies: [Currency]) {
        let balanceData: [BalanceData] = currencies.map {
            BalanceData(currency: $0.symbol, value: 0.0)
        }
        self.balanceViewModel.saveCurrencies(balanceData)
    }
    
    /// Saving A Default Balance for Convertion
    private func checkLaunchedBefore() {
        if !UserDefaults.standard.hasLaunchBefore  {
            self.balanceViewModel.saveDefaultBalance()
        }
    }
    
    /// Save Converted Currency to the Local Database
    /// - Parameter convertedValue: Value after Convertion to Other "Currency"
    /// - Parameter initialAmountValue: Value before Convertion to Other "Currency"
    /// - Parameter beforeCurrency: Currency of the initialAmountValue about to convert
    /// - Parameter afterCurrency: Currency of the Converted value
    private func saveConvertedCurrency(
        convertedValue: Double,
        initialAmountValue: Double,
        from beforeCurrency: Currency,
        to afterCurrency: Currency) {
        
        self.balanceViewModel.saveBalance(
            convertedValue: convertedValue,
            initialAmountValue: initialAmountValue,
            from: beforeCurrency,
            to: afterCurrency)
        .subscribe(
            onNext: { [weak self] (balanceData: [BalanceData]) in
                guard let self = self else { return}
                self.balanceViewModel.balance.onNext(balanceData)
                let doubleReceiveAmount = Double(convertedValue).roundTo(places: 2)
                self.receiveRowViewModel.input.amount.onNext("\(doubleReceiveAmount)")
            },
            onError: { [weak self] (error: Error) in
                guard let self = self else { return}
                self.showErrorAlert(with: error)
            }
        ).disposed(by: self.disposeBag)
    }
    
    private func currencyConvertAlert(
        convertedValue: Double,
        initialAmountValue: Double,
        from beforeCurrency: Currency,
        to afterCurrency: Currency) {
        
        let alert = UIAlertController(
            title: "Currency Converted",
            message: """
                    \n
                    You have converted \(initialAmountValue) \(beforeCurrency.symbol) to
                    \(convertedValue) \(afterCurrency.symbol). Commission Fee - 0.70 EUR
                    """,
            preferredStyle: .alert
        )        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] (alertAction: UIAlertAction) -> Void in
            guard let self = self else { return }
            
            self.saveConvertedCurrency(
                convertedValue: convertedValue,
                initialAmountValue: initialAmountValue,
                from: beforeCurrency,
                to: afterCurrency
            )
        })
        
        self.present(alert,animated: true, completion: nil )
    }
    
    /// Show Allert if convertion is not possible
    /// - Parameter error: just an error
    private func showErrorAlert(with error: Error) {
        let alert = UIAlertController(
            title: "Oooops",
            message: "\(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true, completion: nil )
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
            let receiveCurrency = self.receiveRowViewModel.output.currency,
            let initialAmountValue: Double = Double(self.sellRowViewModel.output.amount.value)
        else { return }
        
        let sellCurrency = self.sellRowViewModel.output.currency
        
        if receiveCurrency.symbol == sellCurrency.symbol {
            self.showErrorAlert(with: ConvertionError.sameCurrencyError)
        }
        
        do {
            let finalValue: Double = try self.balanceViewModel.computeConvertion(
                receiveCurrency: receiveCurrency,
                sellCurrency: sellCurrency,
                amountToConvert: initialAmountValue
            )
            
            self.currencyConvertAlert(
                convertedValue: finalValue,
                initialAmountValue: initialAmountValue,
                from: self.sellRowViewModel.output.currency,
                to: receiveCurrency
            )
        } catch let error {
            self.showErrorAlert(with: error)
        }

    }
}

// MARK: - Network API Access
extension MainVC {
    
    @objc private func fetchCurrency() {
        HUD.show(HUDContentType.progress)
        self.delegate?.getCurrency { [weak self] (exchange: Exchange) -> Void in
            guard let self = self else { return }
            HUD.hide(afterDelay: 1, completion: nil)
            self.exchange = exchange
            let currencies = exchange.rates
                .map { Currency(symbol: $0.key, rate: $0.value) }
                .sorted(
                    by: { (currency1: Currency, currency2: Currency) -> Bool in
                        return currency1.symbol.lowercased() < currency2.symbol.lowercased()
                    }
                )
            print("fetch again")
            self.setPickerValues(currencies: currencies)
            self.interval = 5
            if !UserDefaults.standard.hasLaunchBefore  {
                self.saveCurrencies(currencies)
                UserDefaults.standard.hasLaunchBefore = true
            }
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

// MARK: - MainViewDelegate Methods
extension MainVC: MainViewDelegate {
    public func keyBoardShown() {
        self.fetchTimer?.invalidate()
        self.fetchTimer = nil
    }
    
    public func keyBoardHidden() {
        if self.fetchTimer == nil {
            self.scheduledTimerWithTimeInterval()
        }
    }
}
