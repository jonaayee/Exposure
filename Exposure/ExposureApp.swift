//
//  ExposureApp.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/15/24.
//

import SwiftUI
/* #if os(iOS)
import UIKit
#endif */


@main
struct ExposureApp: App {
    var body: some Scene {
        WindowGroup {
            iOSContentView()
        }
    }
}


/*future code for multi-platform
 
 @main
 struct ExposureApp: App {
 var body: some Scene {
 WindowGroup {
 #if os(iOS)
 if UIDevice.current.userInterfaceIdiom == .pad {
 iPadOSContentView()
 } else {
 iOSContentView()
 }
 #if os(macOS)
 macOSContentView()
 #if os(visionOS)
 visionOSContentView()
 #endif
 }
 }
 }
 */
