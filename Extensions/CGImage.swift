//
//  CGImage.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/6/24.
//

import SwiftUI

extension CGImage {
    func toSwiftUIImage() -> UIImage {
        return UIImage(cgImage: self)
    }

    func toSwiftUIImageOrientationCorrected() -> UIImage {
        return UIImage(cgImage: self, scale: 1.0, orientation: .right)
    }
}
