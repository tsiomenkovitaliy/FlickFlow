//
//  MovieResponse.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/17/25.
//


struct MovieResponse: Decodable {
    let results: [Movie]
    let page: Int
}