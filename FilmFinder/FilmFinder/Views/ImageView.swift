//
//  ImageView.swift
//  FilmFinder
//
//  Created by Tatiane Silva on 10/07/24.
//

import SwiftUI

struct ImageView: View {
    @StateObject private var viewModel = ImageViewModel()
    let posterPath: String

    var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Rectangle()
                    .fill(Color.gray)
            }
        }
        .onAppear {
            viewModel.fetchImage(for: posterPath)
        }
    }
}
