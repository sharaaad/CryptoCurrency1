//
//  MockSession.swift
//  CryptoCurrencyTests
//
//  Created by admin on 28/04/22.
//

import Foundation
@testable import CryptoCurrency

class MockSession: Session {
    
    func dataTask(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            if url.absoluteString.contains("datafailure") {
                completion(nil, nil, nil)
            } else if url.absoluteString.contains("decodefailure") {
                let bundle = Bundle(for: MockCryptoAPIManager.self)
                
                guard let urlString = bundle.url(forResource: "DecodeErrorResponse", withExtension:".json") else  {
                    completion(nil, nil, nil)
                    return
                }

                URLSession.shared.dataTask(with: urlString) { (data, response, error) in
                    completion(data, nil, nil)
                }.resume()
            } else {
                let bundle = Bundle(for: MockCryptoAPIManager.self)
                
                guard let urlString = bundle.url(forResource: "SuccessResponse", withExtension:".json") else  {
                    completion(nil, nil, nil)
                    return
                }

                URLSession.shared.dataTask(with: urlString) { (data, response, error) in
                    completion(data, nil, nil)
                }.resume()
            }
        }
        
    }

}
