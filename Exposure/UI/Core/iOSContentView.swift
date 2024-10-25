//
//  iOSContentView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/15/24.
//

import SwiftUI
import PhotosUI

struct iOSContentView: View {
    
    // for bottom controls
    var viewStates = ["projects", "all photos"]
    @State private var viewState = "projects"
    // ----------------------------------------
    // Photo Import Service
    @State public var photoPickerShowing: Bool = false
    @State private var pickerItems = [PhotosPickerItem]()
    @State public var selectedImages = [Image]()
    // ----------------------------------------
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if viewState == "projects" {
                        ProjectViews()
                    } else {
                        AllPhotosView(selectedImages: $selectedImages)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Exposure")
                            .font(.largeTitle)
                            .bold()
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        NavigationLink(destination: iOSSettingsView()) {
                            Image(systemName: "gear.circle")
                        }
                    }
                }
                .overlay(alignment: .bottom) {
                    HStack {
                        Picker("Projects view or all photos view.", selection: $viewState) {
                            ForEach(viewStates, id: \.self) { viewState in
                                Text(viewState)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 234)
                        .padding(.leading, 16)
                        Spacer()
                        HStack {
                            Button {
                                print("idk, bring up the share sheet if you feel like it ig...")
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .frame(width: 36, height: 36)
                            }
                            .background(.ultraThickMaterial)
                            .clipShape(Circle())
                            .padding(.trailing, 2)
                            PhotosPicker(selection: $pickerItems,
                                         matching: .images
                            ) {
                                Image(systemName: "plus")
                                    .frame(width: 36, height: 36)
                            }
                            .background(.ultraThickMaterial)
                            .clipShape(Circle())
                            .onChange(of: pickerItems) {
                                Task {
                                    selectedImages.removeAll()
                                    
                                    for item in pickerItems {
                                        if let loadedImage = try? await item.loadTransferable(type: Image.self) {
                                            selectedImages.append(loadedImage)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.trailing, 16)
                    }
                }
                .padding(.horizontal, 6)
            }
        }
        
    }
}

#Preview {
    iOSContentView()
}

