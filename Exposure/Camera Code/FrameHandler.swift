//
//  ContentView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/28/24.
//

import AVFoundation
import UIKit
import CoreImage
import Photos

enum selectedAspectRatio {
    case aspect4to3
    case aspect16to9
    case aspect1to1
    case fullscreen
}

class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    private var permissionGranted = true  // permission status
    private let captureSession = AVCaptureSession()  // AVCaptureSession instance
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    
    private var videoOutput = AVCaptureVideoDataOutput()  // Output
    private var currentAspectRatio: selectedAspectRatio = .aspect4to3 {
        didSet { configureAspectRatio() }
    }

    override init() {
        super.init()
        self.checkPermission() 
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()  // sets up capture session
            self.captureSession.startRunning()
        }
    }
    
    deinit { // removes process
            NotificationCenter.default.removeObserver(self)
        }

    // Check for camera permission and request if not determined
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.permissionGranted = true  // Permission granted
        case .notDetermined:
            self.requestPermission()  // Request permission if not determined
        default:
            self.permissionGranted = false  // Permission denied or restricted
        }
    }

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }

    func setupCaptureSession() {
        guard permissionGranted else { return }
        
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else { return }
        
        captureSession.addInput(videoDeviceInput)  // camera input
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)  // camera output
        
        configureAspectRatio()
    }
    
    private func configureAspectRatio() {
        sessionQueue.async { [unowned self] in
            self.captureSession.beginConfiguration()
            
            switch self.currentAspectRatio {
            case .aspect4to3:
                self.captureSession.sessionPreset = .photo // figure out what photo means
            case .aspect16to9:
                self.captureSession.sessionPreset = .hd4K3840x2160 // see if there is a possiblilty for a higher resolution
            case .aspect1to1:
                self.captureSession.sessionPreset = .cif352x288 // find a high resolution square
            case .fullscreen:
                self.captureSession.sessionPreset = .high // figure out what high means
            }
            
            self.captureSession.commitConfiguration()
        }
    }

    // to change the aspect ratio
    func setAspectRatio(_ aspectRatio: selectedAspectRatio) {
        self.currentAspectRatio = aspectRatio
    }
    
    func capturePhoto() {
        guard let cgImage = frame else { return }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: UIImage(cgImage: cgImage))  // saving image to apple photos/icloud
        }, completionHandler: { success, error in
            if let error = error {
                print("Error saving photo: \(error.localizedDescription)")  // failed
            } else if success {
                print("Photo saved successfully")  // success
            }
        })
    }
    // MARK: - Background/Foreground Handling
       @objc private func appDidEnterBackground() {
           sessionQueue.async { [weak self] in
               self?.captureSession.stopRunning()
           }
       }

       @objc private func appWillEnterForeground() {
           sessionQueue.async { [weak self] in
               self?.captureSession.startRunning()
           }
       }
}

// Extension to handle sample buffer processing for video output
extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }  // Convertion sample buffer to CGImage
        
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage  // Update the frame on the main queue
        }
    }

    // Helper method to convert CMSampleBuffer to CGImage
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
}
