//
//  DetailsViewModel.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/18/25.
//
import Foundation

final class DetailsViewModel: ObservableObject {
    @Published var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
}
