//
//  Image.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/6/24.
//

import SwiftUI

extension Image {
    init?(cgImage: CGImage?) {
        guard let cgImage = cgImage else { return nil }
        let uiImage = cgImage.toSwiftUIImage()
        self.init(uiImage: uiImage)
    }
}
