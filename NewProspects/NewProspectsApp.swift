//
//  NewProspectsApp.swift
//  NewProspects
//
//  Created by Adrino Rosario on 21/12/24.
//

import SwiftData
import SwiftUI

@main
struct NewProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospects.self)
    }
}
