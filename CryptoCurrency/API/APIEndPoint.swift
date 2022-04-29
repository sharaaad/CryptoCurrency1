//
//  APIEndPoint.swift
//  CryptoCurrency
//
//  Created by admin on 28/04/22.
//

import Foundation

struct APIEndPoint {
    static let API_KEY = "B8F38214-4103-4D44-98DA-3891504727E2"
    
    static let baseUrl = "https://rest.coinapi.io/v1/"
    static let exchangeRatePath = "exchangerate/EUR?invert=false&apikey=\(API_KEY)"
}
