//
//  CurrencyListViewController.swift
//  testrevolut
//
//  Created by Nikita Timonin on 13/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import UIKit


final class CurrencyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let currencyService = RateService()
    private var currencyListViewModel: CurrencyListViewModel!
    private var timer: Timer!
    
    enum Constants {
        static let cellHeight: CGFloat = 90
    }
    
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        currencyListViewModel = CurrencyListViewModel()
        obtainCurrencies()
    }
    
    
    // MARK: - Private methods
    
    private func obtainCurrencies() {
        currencyService.delegate = self
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCurrencies),
            userInfo: nil,
            repeats: true)
    }
    
    @objc private func updateCurrencies() {
        let baseCurrencyName = currencyListViewModel.baseCurrency.name
        currencyService.obtainCurrencies(baseCurrency: baseCurrencyName)
    }
    
    private func setupUI() {
        tableView.register(
            UINib(nibName: CurrencyTableViewCell.reusableIdentifier, bundle: nil),
            forCellReuseIdentifier: CurrencyTableViewCell.reusableIdentifier)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
    }

}


extension CurrencyListViewController: RateServiceDelegate {
    
    func rateServiceDidRecieveUpdate(base: String, rates: [String : Double]) {
        let tableViewNeedsUpdate = currencyListViewModel.currencies.isEmpty
        currencyListViewModel.createOrUpdateCurrency(name: base, rate: 1.0)
        rates.forEach { [weak self] (name,rate) in
            self?.currencyListViewModel.createOrUpdateCurrency(name: name, rate: rate)
        }
        
        if tableViewNeedsUpdate {
            tableView.reloadData()
        }
    }
    
}


extension CurrencyListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currencyListViewModel?.currencies ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyTableViewCell.reusableIdentifier,
            for: indexPath) as! CurrencyTableViewCell
        cell.currency = currencyListViewModel?.currencies[indexPath.row]
        cell.inputHandler = { [weak self] (input) in
            self?.currencyListViewModel.updateAmmount(newAmmount: input)
        }
        return cell
    }
    
}


extension CurrencyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
        cell.textField.becomeFirstResponder()
        
        guard let currency = cell.currency else { return }
        
        currencyListViewModel.baseCurrency = currency
        currencyListViewModel.updateAmmount(newAmmount: currency.ammount)
        
        let zeroIndexPath = IndexPath(row: 0, section: 0)
        
        currencyListViewModel.currencies.remove(at: indexPath.row)
        currencyListViewModel.currencies.insert(currency, at: 0)
        
        tableView.beginUpdates()
        tableView.moveRow(at: indexPath, to: zeroIndexPath)
        tableView.scrollToRow(at: zeroIndexPath, at: .top, animated: true)
        tableView.endUpdates()
    }
    
}

