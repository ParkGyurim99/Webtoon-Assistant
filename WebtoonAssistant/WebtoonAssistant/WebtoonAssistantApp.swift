//
//  WebtoonAssistantApp.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/04.
//

import SwiftUI

@main
struct WebtoonAssistantApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
