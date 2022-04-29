//
//  CryptoAPIManagerTests.swift
//  CryptoCurrencyTests
//
//  Created by admin on 28/04/22.
//

import XCTest
@testable import CryptoCurrency

class CryptoAPIManagerTests: XCTestCase {

    var apiManager: CryptoAPI!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        apiManager = CryptoAPI(session: MockSession())
    }

    override func tearDownWithError() throws {
        apiManager = nil
        try super.tearDownWithError()
    }

    func testSuccessGetData() {
        var successRates: [Rate] = []
        let expectation = XCTestExpectation(description: "Success")
        
        let apiRequest = ApiRequest(baseUrl: APIEndPoint.baseUrl, path: APIEndPoint.exchangeRatePath)
        apiManager.getCryptoData(apiRequest: apiRequest, previewMode: false) { result in
            switch result {
            case .success(let rates):
                successRates = rates
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 4)
        
        let literalRates = [Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "$ANRX", rate: 71.25092274044576)),
                            Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "$CINU", rate: 333368636935917.94)),
                            Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "$PAC", rate: 486.74227816843677)),
                            Rate(rawRate: RawRate(time: "2022-04-28T08:35:21.0000000Z", assetIdQuote: "100X", rate: 829601748.8443172))]
        
        XCTAssertEqual(successRates, literalRates)
    }

    func testInvalidURLError() {

        var error: NetworkError?
        let expectation = XCTestExpectation(description: "Invalid URL Error")
        
        let apiRequest = ApiRequest(baseUrl: "This is invalid", path: "Also Invalid")
        apiManager.getCryptoData(apiRequest: apiRequest, previewMode: false) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let err):
                error = err
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 4)
        
        XCTAssertEqual(error, NetworkError.invalidUrl(Constants.invalidUrlMsg))
    }
    
    func testDataNotFoundError() {
        var error: NetworkError?
        let expectation = XCTestExpectation(description: "Data Not Found Error")
        
        let apiRequest = ApiRequest(baseUrl: APIEndPoint.baseUrl, path: "datafailure")
        apiManager.getCryptoData(apiRequest: apiRequest, previewMode: false) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let err):
                error = err
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 4)
        
        XCTAssertEqual(error, NetworkError.dataNotFound(Constants.dataNotFoundMsg))
    }
    
    func testParsingError() {
        var error: NetworkError?
        let expectation = XCTestExpectation(description: "Data Not Found Error")
        
        let apiRequest = ApiRequest(baseUrl: APIEndPoint.baseUrl, path: "decodefailure")
        apiManager.getCryptoData(apiRequest: apiRequest, previewMode: false) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let err):
                error = err
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 4)
        
        XCTAssertEqual(error, NetworkError.parsingError(Constants.parsingErroMsg))
    }
    
}
