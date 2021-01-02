//
//  NetworkManager.swift
//  App For InvestAZ
//
//  Created by Kanan`s Macbook Pro on 12/29/20.
//  Copyright © 2020 Kanan`s Macbook Pro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct NetworkManager {
    static let networkManager = NetworkManager()
    
    let baseUrl = "https://valyuta.com/api"
    
    func getCurrencyList(endpoint: String, completetion: @escaping (_ json: JSON) -> ()) {

        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            fatalError("URL not found!")
        }
        
        AF.request(url, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let currencyList: JSON = JSON(data)
                completetion(currencyList)
                
            case.failure(let e):
                print(e)
            }
        }
    }
    
    func convertCurrency(endpoint: String, mainCurrency: String, dateTime: String ,completetion: @escaping (Result<JSON, Error>) -> ()) {
        
        guard let url = URL(string: "\(baseUrl)\(endpoint)/\(mainCurrency)/\(dateTime)") else {
            return completetion(.failure(NetworkingError.badUrl))
        }
                
        AF.request(url, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let currencyList: JSON = JSON(data)
                completetion(.success(currencyList))
                
            case.failure(let e):
                completetion(.failure(e))
            }
        }
    }
    
}

enum NetworkingError: Error {
    case badUrl
}
