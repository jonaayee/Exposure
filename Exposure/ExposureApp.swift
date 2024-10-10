//
//  ExposureApp.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/9/24.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

@main
struct ExposureApp: App {
    var body: some Scene {
        WindowGroup {
#if os(iOS)
            //if UIDevice.current.userInterfaceIdiom == .pad {
            // iPadOSViewHandler
            //  } else {
            iOSViewHandler()
      //  }
#elseif os(macOS)
            // macOSViewHandler
#elseif os(visionOS)
            // visionOSViewHandler
#endif
        }
    }
}
