//
//  APIConfiguration.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/18/25.
//


import Foundation
import Alamofire

// 1. Протокол для API конфигурации
protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

// 2. Enum для всех эндпоинтов
enum MovieEndpoint: APIConfiguration {
    case popular(page: Int)
    case search(query: String)
    case favorites
    case movieDetails(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .popular, .search, .movieDetails, .favorites: 
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .popular: return "/3/movie/popular"
        case .search: return "/3/search/movie"
        case .favorites: return "/3/account/{account_id}/favorite/movies"
        case .movieDetails(let id): return "/3/movie/\(id)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .popular(let page):
            return ["page": page, "api_key": Config.tmdbAPIKey, "language": "en-US"]
        case .search(let query):
            return ["query": query]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseURL = try Config.tmdbBaseURL.asURL()
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 10
        
        urlRequest.headers.add(.authorization(bearerToken: Config.tmdbAccessKey))
        urlRequest.headers.add(.accept("application/json"))
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
