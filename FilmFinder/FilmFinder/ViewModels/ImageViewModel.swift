//
//  ImageViewModel.swift
//  FilmFinder
//
//  Created by Tatiane Silva on 10/07/24.
//

import Foundation
import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let apiService = ApiService()
    private var cancellables = Set<AnyCancellable>()

    func fetchImage(for path: String) {
        isLoading = true
        errorMessage = nil

        apiService.fetchImage(for: path) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.image = UIImage(data: data)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
