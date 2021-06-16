//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CurrencyModel: Decodable {
    let asset_id_quote: String
    let rate: Double
}

protocol CoinManagerDelegate {
    func didUpdateRate(currency: CurrencyModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    private let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    private let apiKey = "853F2DE5-7F75-422C-9B3E-58B1FF2B098A"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currencyName: String) {
        let urlString =  "\(baseURL)/\(currencyName)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let errorHandler = error {
                self.delegate?.didFailWithError(error: errorHandler)
                return
            }
            
            if let safeData = data {
                if let currency = self.parseJSON(for: safeData) {
                    self.delegate?.didUpdateRate(currency: currency)
                }
            } else {
                return
            }
        }
        
        task.resume()
    }
    
    func parseJSON(for currencyData: Data) -> CurrencyModel? {
        let decoder = JSONDecoder()
        do {
            let currency = try decoder.decode(CurrencyModel.self, from: currencyData)
            return currency
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

      //--header "X-CoinAPI-Key: 73034021-THIS-IS-SAMPLE-KEY"
}
