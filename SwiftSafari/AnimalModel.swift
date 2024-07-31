//
//  AnimalModel.swift
//  SwiftSafari
//
//  Created by Jordy Witteman on 22/07/2024.
//

import Foundation

// MARK: - Model to decode JSON to Swift
//{
//    "type": "African Elephant",
//    "living_country": "Botswana",
//    "image_url": "https://upload.wikimedia.org/wikipedia/commons/6/63/African_elephant_warning_raised_trunk.jpg",
//    "description": "African elephants are the largest land animals on Earth, known for their large ears, tusks, and trunks. They live in matriarchal social structures and are highly intelligent, displaying behaviors such as problem-solving and empathy. They communicate through vocalizations and vibrations that can travel long distances. These elephants play a crucial role in their ecosystems, facilitating seed dispersal and creating water holes used by other animals.",
//    "diet": "vegetables",
//    "threatened_status": true
//},
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
