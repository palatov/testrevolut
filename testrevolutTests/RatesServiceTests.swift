//
//  RatesServiceTests.swift
//  testrevolutTests
//
//  Created by Nikita Timonin on 16/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import XCTest
@testable import testrevolut


final class RatesServiceTests: XCTestCase {

    func testObtainRates() {
        let baseCurrency = "EUR"
        let ratesService = RatesServiceImpl()
        let expectation = self.expectation(description: "Obtain")
        
        var obtainedList: RatesList?
        ratesService.obtainRates(base: baseCurrency) { (ratesList) in
            obtainedList = ratesList
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(obtainedList)
        XCTAssertEqual(baseCurrency, obtainedList?.base ?? "")
        XCTAssertTrue(!(obtainedList?.rates ?? [:]).isEmpty)
    }

}
