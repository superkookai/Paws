//
//  PawsApp.swift
//  Paws
//
//  Created by Weerawut Chaiyasomboon on 23/2/2568 BE.
//

import SwiftUI
import SwiftData

@main
struct PawsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Pet.self)
        }
    }
}
