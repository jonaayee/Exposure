//
//  iOSContentView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/4/24.
//

import SwiftUI
import OSLog

struct iOSContentView: View {
    @State private var tapCount = 0
    
    
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button {
                    tapCount += 1
                    Logger.viewCycle.trace("Tapped \(tapCount) times")
                } label: {
                    Image(systemName: "questionmark.app")
                        .font(.system(size: 64))
                }
                .padding()
                Text("Something interesting is coming...")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Text("app version: \(getAppVersion())")
                Text("build number: \(getBuildNumber())")
                Text("complie time: \(compileDate)")
                    .padding(.bottom, 2)
                // Text("engine version: \(ExposureEngine.version)")
                // Text("engine build: \(ExposureEngine.buildNumber)")
#warning("Engine build information can not be retrieved")
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
    
}

#Preview {
    iOSContentView()
}
