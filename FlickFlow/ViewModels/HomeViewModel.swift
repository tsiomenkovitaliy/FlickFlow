//
//  HomeViewModel.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/17/25.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    private let storageService = MovieStorageService()
    
    @EnvironmentObject var router: Router
    
    @Published var movies: [Movie] = []
    @Published var selectedMovie: Movie?
    
    @Published var error: Error? = nil
    @Published var isLoading: Bool = true
    @Published var currentPage: Int = 1

    
    var cancellables = Set<AnyCancellable>()
    
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
        setupFetchTrigger()
        
        Task {
            await loadLocalMovies()
            await fetchMovies()
        }
    }
    
    private func setupFetchTrigger() {
        $currentPage
            .sink { [weak self] _ in
                Task { await self?.fetchMovies() }
            }
            .store(in: &cancellables)
    }
    
    func incrementPage() {
        currentPage += 1
    }
    
    @MainActor
    func fetchMovies() async {
        isLoading = true
        
        do {
            let newMovies = try await movieService.fetchPopularMovies(page: currentPage)
            movies += newMovies
            
            try await storageService.saveMoviesIfNeeded(newMovies)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    // MARK: - Core Data
    
    func saveMoviesToLocalStorage() async {
        do {
            for movie in movies {
                try await storageService.saveMovie(movie)
            }
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }

    func loadLocalMovies() async {
        do {
            let localMovies = try await storageService.fetchAllMovies()
            movies = localMovies
        } catch {
            print("Ошибка загрузки: \(error)")
        }
    }
}
