//
//  MovieViewModel.swift
//  FilmFinder
//
//  Created by Tatiane Silva on 09/07/24.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private var apiService = ApiService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMovies() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchMovies { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
