//
//  RandomRecipe.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 09/03/2022.
//

import Foundation


struct RandomRecipe: Decodable{
    let recipes: [RRecipe]
}

struct RRecipe: Decodable{
    
    let id: Int?
    let name: String?
    let readyInMinutes: Int?
    let link: String?
    let image: String?
    let content: String?
    let instructions: String?
    
    enum CodingKeys: String, CodingKey{
        case id, name = "title"
        case readyInMinutes, link = "sourceUrl"
        case image, content = "summary"
        case instructions


    }
    
    
    
    
    
}

// TODO: make enum of CodingKey for id, title, sourceUrl, image, summary : like in SearchRecipes

