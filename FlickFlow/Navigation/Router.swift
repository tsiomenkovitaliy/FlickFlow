//
//  AppRouter.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/18/25.
//


import SwiftUI

class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func push(to view: Route) {
        path.append(view)
    }

    func pop() {
        path.removeLast()
    }
}
