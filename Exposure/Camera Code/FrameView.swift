//
//  FrameView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/28/24.
//

import SwiftUI

struct FrameView: View {
    
    var image: CGImage?
    private let label = Text("Frame") // Identifies the image
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
        } else {
            Color.black
            Text("No camera feed available")
        }
    }
}

#Preview {
    FrameView()
}
