//
//  FrameView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/5/24.
//

import SwiftUI
import ExposureEngine
import OSLog

struct FrameView: View {
    @ObservedObject var frameHandler = FrameHandler() // An object presenting what the camera is seeing, @ObservedObject REQUIRED
    var image: CGImage? { frameHandler.frame } // Retrieving the frame from framehandler structure
    let label = Text("Viewing Frame") // Default text, typically used by voiceover
    @State private var SelectedAspectRatio: selectedAspectRatio = .aspect4to3 // The current aspect ratio
    
    var body: some View {
        ZStack {
            if let image = image { // Displays camera feed
                Image(image, scale: 1.0, orientation: .up, label: label)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No camera feed available...")
            }
            GeometryReader { geometry in
                Rectangle()
                    .stroke(Color.blue, lineWidth: 3) // Customize frame color and width
                    .aspectRatio(aspectRatio(for: SelectedAspectRatio), contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            VStack {
                Spacer()
                HStack {
                    Picker("Aspect Ratio", selection: $SelectedAspectRatio) {
                        Text("4:3").tag(selectedAspectRatio.aspect4to3)
                        Text("16:9").tag(selectedAspectRatio.aspect16to9)
                        Text("1:1").tag(selectedAspectRatio.aspect1to1)
                        Text("Fullscreen").tag(selectedAspectRatio.fullscreen)
                    }
                    .pickerStyle(.menu)  // Optional style, for horizontal segments
                    .onChange(of: SelectedAspectRatio) { newAspectRatio in // ios 16 and before
                        Logger.viewCycle.warning("onChange modifier called, not supported on iOS 17 and later.")
                        frameHandler.setAspectRatio(newAspectRatio)  // Update frameHandler's aspect ratio
                    }
                    // capture function (basic)
                    Button("Capture") {
                        frameHandler.capturePhoto()
                    }
                }
            }
        }
    }
    private func aspectRatio(for ratio: selectedAspectRatio) -> CGFloat? {
        switch ratio {
        case .aspect4to3:
            return 3.0 / 4.0
        case .aspect16to9:
            return 9.0 / 16.0
        case .aspect1to1:
#warning("Box renders correctly, camera preview is not 1:1")
            return 1.0
        case .fullscreen:
            return 0.0 // No aspect ratio constraint for fullscreen
        }
    }
}

#Preview {
    FrameView()
}
