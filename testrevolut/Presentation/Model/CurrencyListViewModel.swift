//
//  CurrencyListViewModel.swift
//  testrevolut
//
//  Created by Nikita Timonin on 14/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import UIKit


final class CurrencyListViewModel: NSObject {
    
    var baseCurrency: CurrencyViewModel = CurrencyViewModel.defaultCurrency
    var currencies = [CurrencyViewModel]()
    
    func createOrUpdateCurrency(name: String, rate: Double) {
        let first = currencies.first { (currency) -> Bool in
            guard currency.name == name else { return false }
            currency.rate = rate
            return true
        }
        
        if first == nil {
            let newCurrency = CurrencyViewModel(name: name, rate: rate, ammount: baseCurrency.ammount)
            currencies.append(newCurrency)
        }
    }
    
    func updateAmmount(newAmmount: Double) {
        currencies.forEach { (currency) in
            currency.ammount = newAmmount
        }
    }
    
}
