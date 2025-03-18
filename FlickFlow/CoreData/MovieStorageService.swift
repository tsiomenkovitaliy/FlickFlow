//
//  CoreDataService.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/18/25.
//

import CoreData
import Foundation

final class MovieStorageService {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    // MARK: - CRUD Operations
    func saveMovie(_ movie: Movie) async throws {
        let entity = MovieEntity(context: context)
        entity.id = Int64(movie.id)
        entity.title = movie.title
        entity.overview = movie.overview
        entity.posterPath = movie.posterPath
        entity.voteAverage = movie.voteAverage
        entity.releaseDate = movie.releaseDate
        
        try await context.perform {
            try self.context.save()
        }
    }
    
    func fetchAllMovies() async throws -> [Movie] {
        try await context.perform {
            let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
            let entities = try self.context.fetch(request)
            return entities.map { $0.toMovie() }
        }
    }
    
    func saveMoviesIfNeeded(_ movies: [Movie]) async throws {
        try await context.perform {
            for movie in movies {
                let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", movie.id)
                
                // Проверяем, существует ли уже фильм
                if try self.context.count(for: request) == 0 {
                    let entity = MovieEntity(context: self.context)
                    entity.id = Int64(movie.id)
                    entity.title = movie.title
                    entity.overview = movie.overview
                    entity.posterPath = movie.posterPath
                    entity.voteAverage = movie.voteAverage
                    entity.releaseDate = movie.releaseDate
                }
            }
            try self.context.save()
        }
    }
    
    func clear() async throws {
        try await context.perform {
            let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            var entities = try self.context.fetch(request)
            entities.removeAll()
        }
    }
}

// MARK: - Entity Conversion
extension MovieEntity {
    func toMovie() -> Movie {
        Movie(
            id: Int(id),
            title: title ?? "",
            overview: overview ?? "",
            posterPath: posterPath,
            voteAverage: voteAverage,
            releaseDate: releaseDate ?? ""
        )
    }
}
