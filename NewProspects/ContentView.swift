//
//  ContentView.swift
//  NewProspects
//
//  Created by Adrino Rosario on 21/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ProspectsView(filter: .everyone)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .isContacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.seal")
                }
            
            ProspectsView(filter: .isNotContacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
    }
}

#Preview {
    ContentView()
}
