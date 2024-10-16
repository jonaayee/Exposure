//
//  ExposureApp.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/15/24.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

@main
struct ExposureApp: App {
    var body: some Scene {
        WindowGroup {
            iOSContentView()
        }
    }
}
