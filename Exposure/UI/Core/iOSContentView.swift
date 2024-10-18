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
    @State private var selectedImages = [Image]()
    // ----------------------------------------
    // Errors
    enum possibleErrors: Error {
        case someError
    }
    
    static var wrapper: ErrorWrapper {
        ErrorWrapper(error: possibleErrors.someError, code: nil)
    }
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    ScrollView {
                        ForEach(0..<selectedImages.count, id: \.self) { i in
                            selectedImages[i]
                                .resizable()
                                .scaledToFit()
                        }
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
                    ToolbarItem(placement: .bottomBar) { // need to find a way to seperate them into two different items
                        HStack {
                            Picker("Projects view or all photos view.", selection: $viewState) {
                                ForEach(viewStates, id: \.self) { viewState in
                                    Text(viewState)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(minWidth: 0, maxWidth: 256)
                            .padding(.trailing, 64)
                            Button {
                                print("idk, bring up the share sheet if you feel like it ig...")
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                            PhotosPicker(selection: $pickerItems,
                                         matching: .images
                            ) {
                                Image(systemName: "plus")
                            }
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
                    }
                }
            }
            if selectedImages.isEmpty {
                errorView()
                    .ignoresSafeArea(.all)
            }
        }
    }
}

#Preview {
    iOSContentView()
}

