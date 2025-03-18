//
//  MovieService.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/17/25.
//
import Foundation
import Alamofire

final class MovieService {
    private let networkService = NetworkService.shared
    
    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        let endpoint = MovieEndpoint.popular(page: page)
        let response: MovieResponse = try await networkService.request(endpoint, responseType: MovieResponse.self)
        return response.results
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        let endpoint = MovieEndpoint.search(query: query)
        let response: MovieResponse = try await networkService.request(endpoint, responseType: MovieResponse.self)
        return response.results
    }
}
