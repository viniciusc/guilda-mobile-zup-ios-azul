//
//  ApiService.swift
//  FilmFinder
//
//  Created by Tatiane Silva on 09/07/24.
//

import Foundation

class ApiService {
    
    private let apiKey: String? = {
        do {
            if let path = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"),
               let data = FileManager.default.contents(atPath: path) {
                let dict = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]
                return dict?["API_KEY"] as? String
            }
        } catch {
            print("Error reading plist file: \(error)")
        }
        return nil
    }()

    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let apiKey = apiKey,
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }.resume()
    }
}
