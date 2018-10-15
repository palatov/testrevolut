//
//  RatesListsViewModelTests.swift
//  testrevolutTests
//
//  Created by Nikita Timonin on 16/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import XCTest
@testable import testrevolut


final class RatesListsViewModelTests: XCTestCase {
    
    func testObtainRatesEqualCounts() {
        let viewModel = RatesListViewModel(rateService: RatesServiceMock())
        viewModel.obtainRates(completion: nil)
        
        // Total rates + base
        let rawRatesCount = RatesServiceMock.testRates.count + 1
        XCTAssertEqual(rawRatesCount, viewModel.rates.count)
    }
    
    func testObtainRatesUpdatedBaseRate() {
        let viewModel = RatesListViewModel(rateService: RatesServiceMock())
        viewModel.obtainRates(completion: nil)
        
        XCTAssertEqual(viewModel.baseRate.rate, RatesListViewModel.Constants.baseCurrencyRate)
    }
    
    func testUpdateBaseAmmount() {
        let viewModel = RatesListViewModel(rateService: RatesServiceMock())
        viewModel.obtainRates(completion: nil)
        let newAmmount = 100.0
        viewModel.updateBaseAmmount(newAmmount: newAmmount)
        
        viewModel.rates.forEach { (viewModel) in
            XCTAssertEqual(viewModel.baseAmmount, newAmmount)
        }
    }
    
}
