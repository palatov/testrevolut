//
//  RateService.swift
//  testrevolut
//
//  Created by Nikita Timonin on 13/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import Foundation


protocol RateServiceDelegate: class {
    
    func rateServiceDidRecieveUpdate(base: String, rates: [String : Double])
    
}


final class RateService {
    
    typealias VoidClosure = (() -> Void)
    
    enum Constants {
        static let baseURL = "https://revolut.duckdns.org/latest"
    }
    
    private let session = URLSession(configuration: .default)
    
    weak var delegate: RateServiceDelegate?
    
    func obtainCurrencies(baseCurrency: String) {
        guard let request = createRequest(baseCurrency: baseCurrency) else { return }
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            let currencyList = self.process(data: data)
            DispatchQueue.main.async {
                self.delegate?.rateServiceDidRecieveUpdate(base: currencyList.base, rates: currencyList.rates)
            }
        }
        task.resume()
    }
    
    private func process(data: Data) -> CurrencyList {
        return try! JSONDecoder().decode(CurrencyList.self, from: data)
    }
    
    private func createRequest(baseCurrency: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.baseURL) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "base", value: baseCurrency)
        ]
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
