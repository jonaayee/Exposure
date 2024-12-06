//
//  iOSContentView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/4/24.
//

import SwiftUI
import ExposureEngine
import OSLog

struct iOSContentView: View {
    
    @StateObject private var model = FrameHandler() // Allows use of the class in this struct
    
    @State private var appUnlocked = false
    @State private var showToast = false
    @State private var lockTapCount = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    Button(action: handleTap) {
                        Image(systemName: "questionmark.app")
                            .font(.system(size: 64))
                    }
                    .padding()
                    
                    
                    .padding()
                    Text("Something interesting is coming...")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                    Text("app version: \(getAppVersion())")
                    Text("build number: \(getBuildNumber())")
                    Text("engine version: \(ExposureEngine.version)")
                    Text("engine build: \(ExposureEngine.buildNumber)")
                    Text("complie time: \(compileDate)")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if showToast {
                    VStack {
                        Spacer()
                        ToastView(message: "You are \((lockTapCount - 10) * -1) taps away!")
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: showToast)
                            .padding(.bottom, 50) // Adjust to position as needed
                    }
                }
            }
            .navigationDestination(isPresented: $appUnlocked) {
                FrameView()
            }
        }
    }
    
    // MARK: Build information
    func getAppVersion() -> String {
        /* if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
         return appVersion
         } */
        return "Unknown"
    }
    
    func getBuildNumber() -> String {
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildNumber
        }
        return "Unknown"
    }
    
    var compileDate: Date {
        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? "Info.plist"
        if let infoPath = Bundle.main.path(forResource: bundleName, ofType: nil),
           let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
           let infoDate = infoAttr[FileAttributeKey.creationDate] as? Date
        { return infoDate }
        return Date()
    }
    
    func handleTap() {
        lockTapCount += 1
        Logger.viewCycle.trace("Tapped \(lockTapCount) times")
        if lockTapCount >= 5 && lockTapCount < 10 {
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showToast = false
            }
        } else if lockTapCount == 10 {
            showToast = false
            appUnlocked = true
            lockTapCount = 0
        }
    }
}

#Preview {
    iOSContentView()
}
