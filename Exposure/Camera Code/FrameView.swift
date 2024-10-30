//
//  FrameView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/28/24.
//

import SwiftUI

struct FrameView: View {
    @ObservedObject var frameHandler = FrameHandler()  // The oberseved object for the camera frame
    var image: CGImage? { frameHandler.frame }
    private let label = Text("Frame")
    
    var body: some View {
        VStack {
            if let image = image { // displays camera feed
                Image(image, scale: 1.0, orientation: .up, label: label)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No camera feed available")
            }
            
            // turn this into a picker
            HStack {
                Button("4:3") {
                    frameHandler.setAspectRatio(.aspect4to3)
                }
                Button("16:9") {
                    frameHandler.setAspectRatio(.aspect16to9)
                }
                Button("1:1") {
                    frameHandler.setAspectRatio(.aspect1to1)
                }
                Button("Fullscreen") {
                    frameHandler.setAspectRatio(.fullscreen)
                }
                .padding()
                
                // capture function (basic)
                Button("Capture") {
                    frameHandler.capturePhoto()
                }
                .padding()
            }
        }
    }
}

#Preview {
    FrameView()
}
