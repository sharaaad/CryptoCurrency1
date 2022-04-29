//
//  ContentViewModelTest.swift
//  CryptoCurrencyTests
//
//  Created by admin on 27/04/2022.
//

import XCTest
import Combine
@testable import CryptoCurrency

class ContentViewModelTest: XCTestCase {
    var mockCryptoAPIManager: MockCryptoAPIManager!
    var viewModel: ContentViewModel!
    var subscribers: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCryptoAPIManager = MockCryptoAPIManager()
        subscribers = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        mockCryptoAPIManager = nil
        viewModel = nil
        subscribers = nil
        try super.tearDownWithError()
    }
    
    func testCalculateRates() {
        viewModel = ContentViewModel(networkManager: mockCryptoAPIManager)
        let rate = Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "$ANRX", rate: 71.250922740445768939797916784))
        let amount = viewModel.calculateRate(rate: rate)
        
        XCTAssertEqual(amount, 7125.092274044578)
    }
    
    func testRefereshDataSuccess()  {
        
        viewModel = ContentViewModel(networkManager: mockCryptoAPIManager)
        
        var successRates: [Rate] = []
        let expectation = XCTestExpectation(description: "Successfully Retrieved Rates")
        
        viewModel.$rates.dropFirst().sink { rates in
            successRates = rates
            expectation.fulfill()
        }.store(in: &subscribers)
        
        viewModel.refreshData()
        wait(for: [expectation], timeout: 4)
        
        let literalRates = [Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "$ANRX", rate: 71.25092274044576)),
                            Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "$CINU", rate: 333368636935917.94)),
                            Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "$PAC", rate: 486.74227816843677)),
                            Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "100X", rate: 829601748.8443172))]

        XCTAssertEqual(successRates, literalRates)
    }

    func testRefereshDataFailure()  {
        viewModel = ContentViewModel(networkManager: mockCryptoAPIManager, showPreview: true)
        
        var failureRates: [Rate] = []
        let expectation = XCTestExpectation(description: "Failed to Retrieve Rates")
        
        viewModel.$rates.dropFirst().sink { rates in
            failureRates = rates
            expectation.fulfill()
        }.store(in: &subscribers)
        
        viewModel.refreshData()
        wait(for: [expectation], timeout: 4)

        XCTAssertEqual(failureRates, [])

    }


}
