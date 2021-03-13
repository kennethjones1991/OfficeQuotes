//
//  QuoteController.swift
//  OfficeQuotes
//
//  Created by Kenneth Jones on 3/13/21.
//

import Foundation

class QuoteController {
    enum NetworkError: Error {
        case noData, tryAgain, networkFailure
    }
    
    private let baseURL = URL(string: "https://officeapi.dev/api/quotes/random")!
    
    func fetchQuote(searchTerm: String, completion: @escaping (Result<Quote, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Try again! Error: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 401 {
                print("Oh no, network failure: \(response)")
                completion(.failure(.networkFailure))
                return
            }
            
            guard let data = data else {
                print("No data received from fetchQuote")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let quote = try decoder.decode(Quote.self, from: data)
                completion(.success(quote))
            } catch {
                print("Error decoding quote data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }
}
