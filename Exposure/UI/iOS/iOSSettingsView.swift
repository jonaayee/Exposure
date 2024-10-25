//
//  iOSSettingsView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/15/24.
//

import SwiftUI

struct iOSSettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("About", destination: iOSAboutAppView())
                NavigationLink("Camera", destination: iOSMainCameraSettingsView())
                NavigationLink("Appearance", destination: iOSAppearanceView())
                NavigationLink("Agreements", destination: iOSPrivacyAndTermsView())
                NavigationLink("help", destination: iOSHelpView())
                    .foregroundStyle(.blue)
            }
            .navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    iOSSettingsView()
}

struct iOSAboutAppView: View {
    var body: some View {
        Text("About App")
    }
}

struct iOSMainCameraSettingsView: View {
    var body: some View {
        Text("Camera Settings")
    }
}

struct iOSAppearanceView: View {
    var body: some View {
        Text("Appearance")
    }
}

struct iOSPrivacyAndTermsView: View {
    var body: some View {
        Text("Privacy Agreement and Terms of Service")
    }
}

struct iOSHelpView: View {
    var body: some View {
        Text("Help")
        Text("This will later open a website using safari in-app browser.")
    }
}
