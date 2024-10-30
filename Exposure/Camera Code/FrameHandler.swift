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
    @Published var frame: CGImage?  // Published frame to update the UI
    private var permissionGranted = true  // Stores camera permission status
    private let captureSession = AVCaptureSession()  // AVCaptureSession instance
    private let sessionQueue = DispatchQueue(label: "sessionQueue")  // Queue for configuring the session
    private let context = CIContext()  // CIContext for converting CIImage to CGImage
    
    private var videoOutput = AVCaptureVideoDataOutput()  // Output for video data
    private var currentAspectRatio: selectedAspectRatio = .aspect4to3 {  // Default aspect ratio
        didSet { configureAspectRatio() }  // Configure session when aspect ratio changes
    }

    override init() {
        super.init()
        self.checkPermission()  // Check camera permissions
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()  // Setup capture session in background
            self.captureSession.startRunning()  // Start capturing
        }
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

    // Request permission for camera access
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted  // Set permission status
        }
    }

    // Setup the capture session, configure input/output, and add to session
    func setupCaptureSession() {
        guard permissionGranted else { return }  // Ensure permission is granted
        
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else { return }
        
        captureSession.addInput(videoDeviceInput)  // Add camera input to session
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))  // Set delegate for video output
        captureSession.addOutput(videoOutput)  // Add video output to session
        
        configureAspectRatio()  // Set the initial aspect ratio
    }
    
    // Configure session preset based on the selected aspect ratio
    private func configureAspectRatio() {
        sessionQueue.async { [unowned self] in
            self.captureSession.beginConfiguration()  // Start configuration
            
            switch self.currentAspectRatio {
            case .aspect4to3:
                self.captureSession.sessionPreset = .photo  // 4:3 aspect ratio
            case .aspect16to9:
                self.captureSession.sessionPreset = .hd4K3840x2160  // 16:9 aspect ratio
            case .aspect1to1:
                self.captureSession.sessionPreset = .cif352x288
            case .fullscreen:
                self.captureSession.sessionPreset = .high  // Fullscreen aspect ratio
            }
            
            self.captureSession.commitConfiguration()  // Commit configuration
        }
    }

    // Public method to set the aspect ratio
    func setAspectRatio(_ aspectRatio: selectedAspectRatio) {
        self.currentAspectRatio = aspectRatio  // Update current aspect ratio
    }
    
    // Capture the current frame and save to Photos library
    func capturePhoto() {
        guard let cgImage = frame else { return }  // Ensure there's a valid frame
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: UIImage(cgImage: cgImage))  // Save image to Photos
        }, completionHandler: { success, error in
            if let error = error {
                print("Error saving photo: \(error.localizedDescription)")  // Print error if saving fails
            } else if success {
                print("Photo saved successfully")  // Confirm success
            }
        })
    }
}

// Extension to handle sample buffer processing for video output
extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }  // Convert sample buffer to CGImage
        
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage  // Update the frame on the main queue
        }
    }

    // Helper method to convert CMSampleBuffer to CGImage
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        return context.createCGImage(ciImage, from: ciImage.extent)  // Convert CIImage to CGImage
    }
}
