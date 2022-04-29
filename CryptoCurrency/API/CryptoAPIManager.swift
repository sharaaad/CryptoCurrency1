//
//  CryptoAPIManager.swift
//  CryptoCurrency
//
//  Created by admin on 26/04/2022.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidUrl(String)
    case dataNotFound(String)
    case parsingError(String)
}

protocol CryptoAPIType{
    func getCryptoData(apiRequest: ApiRequest, previewMode: Bool, _ completion: @escaping (Result<[Rate], NetworkError>) -> ())
}

class CryptoAPI: CryptoAPIType {
    
    private var session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    func getCryptoData(apiRequest: ApiRequest, previewMode: Bool, _ completion: @escaping (Result<[Rate], NetworkError>) -> ()) {
  
        if previewMode {
            completion(.success(Rate.sampleRates))
            return
        }
        
        guard let url = apiRequest.getUrl() else {
            completion(.failure(.invalidUrl(Constants.invalidUrlMsg)))
            return
        }
        
        session.dataTask(url: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.dataNotFound(Constants.dataNotFoundMsg)))
                return
            }
            
            do {
                let ratesData = try JSONDecoder().decode(Crypto.self, from: data)
                let rates = ratesData.rates.compactMap {
                    return Rate(rawRate: $0)
                }
                completion(.success(rates))
            } catch {
                print(error)
                completion(.failure(.parsingError(Constants.parsingErroMsg)))
            }
        }
    }
}
