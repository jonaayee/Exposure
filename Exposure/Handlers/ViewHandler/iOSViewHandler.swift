//
//  iOSViewHandler.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/9/24.
//

import SwiftUI

struct iOSViewHandler: View {
    var body: some View {
        TabView { // Tab Bar will be phased out before final build
            Tab("default_view", systemImage: "questionmark.square.dashed") {
                HomeView()
            }
    
            Tab("add_button", systemImage: "questionmark.square.dashed") {
                Text("Put a UsersView here")
            }
            
            Tab("godmode_menu", systemImage: "questionmark.square.dashed") {
                Text("Put a SearchView here")
            }
        }
    }
}

#Preview {
    iOSViewHandler()
}
