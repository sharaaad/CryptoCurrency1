//
//  MockCryptoAPIManager.swift
//  CryptoCurrencyTests
//
//  Created by admin on 27/04/2022.
//

import XCTest

@testable import CryptoCurrency

class MockCryptoAPIManager: CryptoAPIType {
    
    let API_KEY = "B8F38214-4103-4D44-98DA-3891504727E2"
    
    func getCryptoData(apiRequest: ApiRequest, previewMode: Bool, _ completion: @escaping (Result<[Rate], NetworkError>) -> ()) {
        
        let resourceName = previewMode ? "DecodeErrorResponse" : "SuccessResponse"
        
        let bundle = Bundle(for: MockCryptoAPIManager.self)
        
        guard let urlString = bundle.url(forResource: resourceName, withExtension:".json") else  {
            completion(.failure(.dataNotFound(Constants.dataNotFoundMsg)))
            return
        }

        
        URLSession.shared.dataTask(with: urlString) { (data, response, error) in
            guard let data = data else {
                print("CryotiAPI: Could not retrieve data")
                completion(.failure(.invalidUrl(Constants.invalidUrlMsg)))
                return
            }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                do {
                    let ratesData = try JSONDecoder().decode(Crypto.self, from: data)
                    let rates = ratesData.rates.compactMap { rawRate in
                        return Rate(rawRate: rawRate)
                    }
                    completion(.success(rates))
                    

                } catch {
                    print("CryotiAPI: \(error)")
                    completion(.failure(.parsingError(Constants.parsingErroMsg)))
                }
            }
            
        }
        .resume()
        
    }
    
}
    
    

