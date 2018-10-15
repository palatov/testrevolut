//
//  RatesService.swift
//  testrevolut
//
//  Created by Nikita Timonin on 13/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import Foundation


protocol RatesService {
    
     func obtainRates(base: String, completion: @escaping ((RatesList) -> Void))
    
}


final class RatesServiceImpl: RatesService {
    
    // MARK: - Types
    
    typealias VoidClosure = (() -> Void)
    
    enum Constants {
        static let baseURL = "https://revolut.duckdns.org/latest"
    }
    
    
    // MARK: - Private properties
    
    private let session = URLSession(configuration: .default)
    
    
    // MARK: - Public methods
    
    func obtainRates(base: String, completion: @escaping ((RatesList) -> Void)) {
        guard let request = createRequest(base: base) else { return }
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self, let data = data else { return }
            let currencyList = self.process(data: data)
            DispatchQueue.main.async {
                completion(currencyList)
            }
        }
        task.resume()
    }
    
    
    // MARK: - Private methods
    
    private func process(data: Data) -> RatesList {
        return try! JSONDecoder().decode(RatesList.self, from: data)
    }
    
    private func createRequest(base: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.baseURL) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "base", value: base)
        ]
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
}
