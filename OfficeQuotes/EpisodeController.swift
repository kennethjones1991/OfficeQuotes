//
//  EpisodeController.swift
//  OfficeQuotes
//
//  Created by Kenneth Jones on 3/13/21.
//

import Foundation

class EpisodeController {
    enum NetworkError: Error {
        case noData, tryAgain, networkFailure
    }
    
    private let baseURL = URL(string: "https://officeapi.dev/api/episodes/random")!
    
    func fetchEpisode(completion: @escaping (Result<Episode, NetworkError>) -> Void) {
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
                print("No data received from fetchEpisode")
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let episode = try decoder.decode(Episode.self, from: data)
                completion(.success(episode))
            } catch {
                print("Error decoding episode data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }
}
