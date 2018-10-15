//
//  RatesServiceMock.swift
//  testrevolutTests
//
//  Created by Nikita Timonin on 16/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import Foundation
@testable import testrevolut


final class RatesServiceMock: RatesService {
    
    static let testRates = ["AUD":1.6153,"BGN":1.9545,"BRL":4.7886,"CAD":1.5328,"CHF":1.1267,"CNY":7.9397,
                            "CZK":25.698,"DKK":7.4517,"GBP":0.89763,"HKD":9.1262,"HRK":7.4291,"HUF":326.27,
                            "IDR":17312.0,"ILS":4.1678,"INR":83.661,"ISK":127.71,"JPY":129.46,"KRW":1303.9,
                            "MXN":22.35,"MYR":4.8087,"NOK":9.7694,"NZD":1.7621,"PHP":62.55,"PLN":4.3154,"RON":4.6354,
                            "RUB":79.521,"SEK":10.584,"SGD":1.5989,"THB":38.104,"TRY":7.623,"USD":1.1626,"ZAR":17.811]
    
    func obtainRates(base: String, completion: @escaping ((RatesList) -> Void)) {
        completion(RatesList(base: "EUR", date: "", rates: RatesServiceMock.testRates))
    }
    
}
