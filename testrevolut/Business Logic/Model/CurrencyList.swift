//
//  CurrencyList.swift
//  testrevolut
//
//  Created by Nikita Timonin on 14/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import Foundation


struct CurrencyList: Decodable{
    let base: String
    let date: String
    let rates: [String: Double]
}
