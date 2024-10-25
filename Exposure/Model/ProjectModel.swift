//
//  ProjectModel.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/21/24.
//

import Foundation
import SwiftUICore

struct ProjectModel: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let image: [Image]
    let imageCount: Int
    let color: Color
    let dateCreated: Date
    let dateUpdated: Date
    
    init(id: UUID, name: String, description: String, image: [Image], imageCount: Int, color: Color, dateCreated: Date, dateUpdated: Date) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.imageCount = image.count
        self.color = color
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
    }
}
