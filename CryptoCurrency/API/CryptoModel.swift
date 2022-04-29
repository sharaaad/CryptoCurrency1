//
//  CryptoModel.swift
//  CryptoCurrency
//
//  Created by admin on 26/04/2022.
//

import Foundation

struct Crypto: Decodable {
    let assetIdBase: String
    let rates: [RawRate]
    
    enum CodingKeys: String, CodingKey {
        case assetIdBase = "asset_id_base"
        case rates
    }
}

struct RawRate: Decodable {
    let time: String?
    let assetIdQuote: String?
    let rate: Double?
    
    enum CodingKeys: String, CodingKey {
        case assetIdQuote = "asset_id_quote"
        case time, rate
    }
}


struct Rate: Equatable, Identifiable {
    var id = UUID()
    let time: String?
    let assetIdQuote: String?
    let rate: Double?
    
    init(rawRate: RawRate?) {
        self.time = rawRate?.time
        self.assetIdQuote = rawRate?.assetIdQuote
        self.rate = rawRate?.rate
    }
    
    static func ==(lhs: Rate, rhs: Rate) -> Bool {
        return (lhs.time == rhs.time) && (lhs.assetIdQuote == rhs.assetIdQuote) && (lhs.rate == rhs.rate)
    }
    
    static var sampleRates: [Rate] {
        var tempRates = [Rate]()
        
        for _ in 1...20 {
            let randomNumber = Double(Array(0...1000).randomElement()!)
            let randomCurrency = ["BTC", "ETH", "XRP", "LOL", "FTW"].randomElement()!
            let rawRate = RawRate(time: "023434353", assetIdQuote: randomCurrency, rate: randomNumber)
            let sampleRate = Rate(rawRate: rawRate)
            tempRates.insert((sampleRate), at: 0)
        }
        return tempRates
    }
}

