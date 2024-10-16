//
//  iOSContentView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/15/24.
//

import SwiftUI

struct iOSContentView: View {
    
    var viewStates = ["projects", "all photos"]
    @State private var viewState = "projects"
    
    var body: some View {
        NavigationStack {
            VStack {
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Exposure")
                        .font(.largeTitle)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink(destination: iOSSettingsView()) {
                        Image(systemName: "gear.circle")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Picker("Projects view or all photos view.", selection: $viewState) {
                            ForEach(viewStates, id: \.self) { viewState in
                                Text(viewState)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(minWidth: 0, maxWidth: 256)
                        .padding(.trailing, 64)
                        Button("Share") {
                            
                        }
                        Button("Import") {
                            
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    iOSContentView()
}
