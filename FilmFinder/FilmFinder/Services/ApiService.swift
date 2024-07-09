//
//  ApiService.swift
//  FilmFinder
//
//  Created by Tatiane Silva on 09/07/24.
//

import Foundation

class ApiService {
    
    // Função para ler a chave da API do arquivo plist
    private func getApiKey() -> String? {
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
    }
    
    // Propriedade para armazenar a chave da API
    private lazy var apiKey: String? = {
        return getApiKey()
    }()
    
    // Função para buscar filmes
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let apiKey = apiKey else {
            print("API Key is missing")
            return
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
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
