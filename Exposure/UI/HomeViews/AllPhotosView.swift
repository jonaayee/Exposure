//
//  AllPhotosView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/24/24.
//

import SwiftUI

struct AllPhotosView: View {
    
    @Binding var selectedImages: [Image]
    
    var body: some View {
        NavigationStack {
            if selectedImages.count == 0 {
                VStack {
                    Text("Import Photos to begin...")
                }
            } else {
                ScrollView {
                    ForEach(0..<selectedImages.count, id: \.self) { i in
                        selectedImages[i]
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
    }
}

// This is not included in the project, only in Xcode Previews as a demo
#Preview {
    @Previewable @State var images = [Image(systemName: "photo")]
    return AllPhotosView(selectedImages: $images)
}
