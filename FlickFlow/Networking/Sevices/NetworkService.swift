//
//  NetworkService.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/18/25.
//
import Foundation
import Alamofire

final class NetworkService: @unchecked Sendable {
    static let shared = NetworkService()
    private let session: Session
    
    private let tmdbAccessKey = Config.tmdbAccessKey
    
    private init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 15
        configuration.headers.add(name: "accept", value: "application/json")
        configuration.headers.add(name: "Authorization", value: tmdbAccessKey)
        session = Session(configuration: configuration)
    }
    
    func request<T: Decodable>(
        _ endpoint: APIConfiguration,
        responseType: T.Type
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            session.request(endpoint)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: self.handleError(error))
                    }
                }
        }
    }
    
    private func handleError(_ error: AFError) -> Error {
        if let underlyingError = error.underlyingError {
            return underlyingError
        }
        return error
    }
}
