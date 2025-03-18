//
//  Route.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/18/25.
//


enum Route {
    case detailsView(Movie)
}

extension Route: Hashable, Decodable {}
