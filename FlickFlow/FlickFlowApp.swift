//
//  FlickFlowApp.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/17/25.
//

import SwiftUI

@main
struct FlickFlowApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var router = Router()
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(homeViewModel)
                .environmentObject(router)
        }
    }
}
