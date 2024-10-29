//
//  ContentView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/28/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var model = FrameHandler() // Allows use of the class in this struct
    
    var body: some View {
        FrameView(image: model.frame)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
