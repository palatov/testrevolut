//
//  RateViewModel.swift
//  testrevolut
//
//  Created by Nikita Timonin on 14/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import Foundation


@objcMembers class RateViewModel: NSObject {
    let name: String
    dynamic var rate: Double
    dynamic var baseAmmount: Double
    
    var totalAmmount: Double {
        return rate * baseAmmount
    }
    
    init(name: String, rate: Double, ammount: Double) {
        self.name = name
        self.rate = rate
        self.baseAmmount = ammount
    }
    
    static var defaultRate: RateViewModel {
        return RateViewModel(
            name: "EUR",
            rate: 1.0,
            ammount: 100)
    }
    
    
}
