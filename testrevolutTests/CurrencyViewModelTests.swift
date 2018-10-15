//
//  CurrencyViewModelTests.swift
//  testrevolutTests
//
//  Created by Nikita Timonin on 16/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import XCTest
@testable import testrevolut


final class RateViewModelTests: XCTestCase {

    func testTotalSum() {
        let viewModel = RateViewModel(name: "RUB", rate: 12.0, ammount: 100.0)
        XCTAssertEqual(viewModel.totalAmmount, viewModel.rate * viewModel.baseAmmount)
    }

}
