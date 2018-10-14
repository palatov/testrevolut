//
//  CurrencyViewModel.swift
//  testrevolut
//
//  Created by Nikita Timonin on 14/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import Foundation


@objcMembers class CurrencyViewModel: NSObject {
    let name: String
    dynamic var rate: Double
    dynamic var ammount: Double
    
    init(name: String, rate: Double, ammount: Double) {
        self.name = name
        self.rate = rate
        self.ammount = ammount
    }
    
    static var defaultCurrency: CurrencyViewModel {
        return CurrencyViewModel(
            name: "EUR",
            rate: 1.0,
            ammount: 100)
    }
}
