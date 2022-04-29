//
//  ContentViewModel.swift
//  CryptoCurrency
//
//  Created by admin on 26/04/2022.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var rates = [Rate]()
    @Published var searchText = ""
    @Published var amount: Double = 100 // Default value
    
    private var networkManager: CryptoAPIType
    private var showPreview: Bool
    
    init(networkManager: CryptoAPIType, showPreview: Bool = false) {
        self.networkManager = networkManager
        self.showPreview = showPreview
    }
    
    var filteredRates: [Rate] {
        return searchText == "" ? rates : rates.filter {
            
            guard let text = $0.assetIdQuote else { return false}
            return text.contains(searchText.uppercased())
        }
    }
    
    func calculateRate(rate: Rate) -> Double {
        return amount * (rate.rate ?? 0.0)
    }
    
    func refreshData() {
        
        let apiRequest = ApiRequest(baseUrl: APIEndPoint.baseUrl, path: APIEndPoint.exchangeRatePath)
        
        networkManager.getCryptoData(apiRequest: apiRequest, previewMode: showPreview, { [weak self] result in
            switch result {
            case .success(let rates):
                DispatchQueue.main.async {
                    self?.rates = rates
                }
            case .failure(let _):
                DispatchQueue.main.async {
                    self?.rates = []
                }
            }
        })
        
    }
}
