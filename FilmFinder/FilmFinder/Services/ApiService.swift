//
//  ApiService.swift
//  FilmFinder
//
//  Created by Tatiane Silva on 09/07/24.
//

import Foundation

class ApiService {
    private let apiKey = "YOUR_API_KEY" // Substitua pelo seu API Key do TMDb

    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1") else {
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
