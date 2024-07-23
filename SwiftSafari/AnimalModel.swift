//
//  AnimalModel.swift
//  SwiftSafari
//
//  Created by Jordy Witteman on 22/07/2024.
//

import Foundation

struct AnimalModel: Identifiable, Codable {
    
    let id: String
    let livingCountry: String
    let imageUrl: String
    let description: String
    let diet: String
    let threatened: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "type"
        case livingCountry = "living_country"
        case imageUrl = "image_url"
        case description = "description"
        case diet = "diet"
        case threatened = "threatened_status"
    }
    
}
