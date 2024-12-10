//
//  FrameView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/5/24.
//

import SwiftUI
import ExposureEngine
import AVFoundation
import OSLog

struct FrameView: View {
    // MARK: - Observed Objects
    @ObservedObject var frameHandler: FrameHandler

    // MARK: - Initializer
    init(frameHandler: FrameHandler = FrameView.createFrameHandler()) {
        self.frameHandler = frameHandler
    }

    // Static factory method to create FrameHandler on the main actor
    @MainActor private static func createFrameHandler() -> FrameHandler {
        return FrameHandler()
    }

    // MARK: - State Properties
    var image: CGImage? { frameHandler.frame }
    let label = Text("Viewing Frame")
    @State private var selectedAspectRatio: SelectedAspectRatio = .aspect4to3
    @State private var selectedFormat: CaptureFormat = .jpg
    @State private var selectedFlashMode: AVCaptureDevice.FlashMode = .off
    @State private var selectedMegapixels: Int = 12
    @State private var useTelephotoCamera: Bool = false
    @State private var captureDelay: Double = 0.0

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Camera Feed
                if let frameImage = image {
                    Image(frameImage, scale: 1.0, orientation: .up, label: label)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                } else {
                    Text("No camera feed available...")
                        .foregroundColor(.gray)
                }

                // Aspect Ratio Overlay
                GeometryReader { geometry in
                    let ratio = calculatedAspectRatio(for: selectedAspectRatio)
                    let finalRatio: CGFloat? = (ratio == 0.0) ? nil : ratio

                    Rectangle()
                        .stroke(Color.blue, lineWidth: 3)
                        .aspectRatio(finalRatio, contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .padding(.horizontal, 10)

                // Controls Overlay
                VStack {
                    Spacer()

                    // Aspect Ratio Picker, Capture Button
                    HStack {
                        Picker("Aspect Ratio", selection: $selectedAspectRatio) {
                            Text("4:3").tag(SelectedAspectRatio.aspect4to3)
                            Text("16:9").tag(SelectedAspectRatio.aspect16to9)
                            Text("1:1").tag(SelectedAspectRatio.aspect1to1)
                            Text("Fullscreen").tag(SelectedAspectRatio.fullscreen)
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedAspectRatio) { newAspectRatio in
                            Logger.viewCycle.debug("Aspect ratio changed to \(newAspectRatio)")
                            frameHandler.setAspectRatio(newAspectRatio)
                        }

                        Button("Capture") {
                            if captureDelay > 0 {
                                frameHandler.capturePhoto(after: captureDelay)
                            } else {
                                frameHandler.capturePhoto()
                            }
                        }
                    }
                    .padding(.bottom, 10)

                    // Additional Controls
                    HStack {
                        // Capture Format Picker
                        Picker("Format", selection: $selectedFormat) {
                            Text("JPG").tag(CaptureFormat.jpg)
                            Text("HEIC").tag(CaptureFormat.heic)
                            Text("DNG").tag(CaptureFormat.dng)
                            Text("PNG").tag(CaptureFormat.png)
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedFormat) { newFormat in
                            frameHandler.captureFormat = newFormat
                            Logger.viewCycle.debug("Capture format changed to \(newFormat)")
                        }

                        // Flash Mode Picker
                        Picker("Flash", selection: $selectedFlashMode) {
                            Text("Off").tag(AVCaptureDevice.FlashMode.off)
                            Text("On").tag(AVCaptureDevice.FlashMode.on)
                            Text("Auto").tag(AVCaptureDevice.FlashMode.auto)
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedFlashMode) { newMode in
                            frameHandler.flashMode = newMode
                            Logger.viewCycle.debug("Flash mode changed to \(newMode.rawValue)")
                        }

                        // Megapixels Picker
                        Picker("MP", selection: $selectedMegapixels) {
                            Text("12MP").tag(12)
                            Text("24MP").tag(24)
                            Text("48MP").tag(48)
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedMegapixels) { newMP in
                            frameHandler.setMegapixels(newMP)
                            Logger.viewCycle.debug("Megapixels changed to \(newMP)")
                        }
                    }
                    .padding(.bottom, 10)

                    // Camera Selection and Timer
                    HStack {
                        // Camera Selection
                        Button("Use Telephoto") {
                            useTelephotoCamera.toggle()
                            if useTelephotoCamera {
                                frameHandler.selectTelephotoCamera()
                                Logger.viewCycle.debug("Switched to telephoto camera.")
                            } else {
                                frameHandler.selectCamera(type: .builtInWideAngleCamera, position: .back)
                                Logger.viewCycle.debug("Switched to back wide-angle camera.")
                            }
                        }

                        Button("Front Camera") {
                            frameHandler.selectFrontCamera()
                            Logger.viewCycle.debug("Switched to front camera.")
                        }

                        // Timer Slider
                        VStack {
                            Text("Capture Delay: \(Int(captureDelay))s")
                            Slider(value: $captureDelay, in: 0...10, step: 1)
                        }
                        .frame(width: 150)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Camera View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Aspect Ratio Helper
    private func calculatedAspectRatio(for ratio: SelectedAspectRatio) -> CGFloat {
        switch ratio {
        case .aspect4to3: return 3.0 / 4.0
        case .aspect16to9: return 9.0 / 16.0
        case .aspect1to1: return 1.0
        case .fullscreen: return 0.0
        }
    }
}

#Preview {
    FrameView()
}
