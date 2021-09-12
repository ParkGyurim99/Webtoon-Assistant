//
//  WebtoonAssistant_CoredataApp.swift
//  WebtoonAssistant_Coredata
//
//  Created by 박규림 on 2021/02/23.
//

import SwiftUI

@main
struct WebtoonAssistant_CoredataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LandingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
