//
//  ApiRequest.swift
//  CryptoCurrency
//
//  Created by admin on 28/04/22.
//

import Foundation

struct ApiRequest {
    
    let baseUrl: String
    let path: String

    func getUrl()-> URL? {
        let urlComponents = URLComponents(string: baseUrl.appending(path))
        return urlComponents?.url
    }
    
}
