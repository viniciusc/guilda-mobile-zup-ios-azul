//
//  ContentView.swift
//  FilmFinder
//
//  Created by Tatiane Silva on 13/06/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    private let apiService = ApiService()

    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                HStack {
                    if let posterPath = movie.posterPath {
                        ImageView(posterPath: posterPath)
                            .frame(width: 100, height: 150)
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 150)
                    }
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.overview)
                            .font(.subheadline)
                            .lineLimit(3)
                    }
                }
            }
            .navigationTitle("Popular Movies")
            .onAppear {
                viewModel.fetchMovies()
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
