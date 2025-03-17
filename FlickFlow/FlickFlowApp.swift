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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
