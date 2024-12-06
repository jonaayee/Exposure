//
//  ExposureApp.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/1/24.
//

import SwiftUI
/*
 Add "import UIKit" only iOS for determining if the device is an iPhone or iPad
 */

@main
struct ExposureApp: App {
    var body: some Scene { // Add different WindowGroups for different operating systems, such as macOS, iOS, and visionOS
        WindowGroup {
            iOSContentView()
        }
    }
}
