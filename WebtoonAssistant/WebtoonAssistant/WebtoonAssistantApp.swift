//
//  WebtoonAssistantApp.swift
//  WebtoonAssistant
//
//  Created by 박규림 on 2021/01/04.
//

import SwiftUI
import Firebase

@main
struct WebtoonAssistantApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            //myWebtoon()
        }
    }
}
