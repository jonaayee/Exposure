//
//  ImageModel.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/21/24.
//

import Foundation
import SwiftUICore

struct imageModel: Identifiable {
    let id: UUID
    let image: Image
    let title: String
    let dateTaken: Date
    let location: String
    
    init(id: UUID, image: Image, title: String, dateTaken: Date, location: String) {
        self.id = id
        self.image = image
        self.title = title
        self.dateTaken = dateTaken
        self.location = location
    }
}
