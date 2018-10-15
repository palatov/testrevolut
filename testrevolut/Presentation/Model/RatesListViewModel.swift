//
//  RatesListViewModel.swift
//  testrevolut
//
//  Created by Nikita Timonin on 14/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import UIKit


final class RatesListViewModel {
    
    // MARK: - Types
    
    enum Constants {
        static let baseCurrencyRate = 1.0
    }
    typealias VoidClosure = (() -> Void)
    
    // MARK: - Public properties
    
    var baseRate: RateViewModel = RateViewModel.defaultRate {
        didSet {
            baseRateWasUpdated = oldValue.name != baseRate.name
            guard baseRateWasUpdated else { return }
            promoteBaseRate()
            obtainRates(completion: nil)
        }
    }
    
    
    // MARK: - Private properties
    
    private(set) var rates = [RateViewModel]()
    private var baseRateWasUpdated = false
    private let ratesService: RatesService
    
    
    // MARK: - Init
    
    init(ratesService: RatesService = RatesServiceImpl()) {
        self.ratesService = ratesService
    }
    
    
    // MARK: - Public methods
    
    func updateBaseAmmount(newAmmount: Double) {
        rates.forEach { (currency) in
            currency.baseAmmount = newAmmount
        }
    }
    
    func obtainRates(completion: VoidClosure?) {
        ratesService.obtainRates(base: baseRate.name) { [weak self] (ratesList) in
            guard let self = self else { return }
            self.updateBaseRate(name: ratesList.base)
            ratesList.rates.forEach { (name,rate) in
                self.createOrUpdateRateViewModel(name: name, rate: rate)
            }
            completion?()
        }
    }
    
    
    // MARK: - Private methods
    
    private func updateBaseRate(name: String) {
        if baseRateWasUpdated {
            updateBaseAmmount(newAmmount: self.baseRate.totalAmmount)
            baseRateWasUpdated = false
        }
        createOrUpdateRateViewModel(name:name, rate: Constants.baseCurrencyRate)
    }
    
    private func promoteBaseRate() {
        guard let index = rates.index(of: baseRate) else { return }
        rates.remove(at: index)
        rates.insert(baseRate, at: 0)
    }
    
    private func createOrUpdateRateViewModel(name: String, rate: Double) {
        let first = rates.first { (currency) -> Bool in
            guard currency.name == name else { return false }
            currency.rate = rate
            return true
        }
        
        if first == nil {
            let newCurrency = RateViewModel(name: name, rate: rate, ammount: baseRate.baseAmmount)
            rates.append(newCurrency)
        }
    }
}
