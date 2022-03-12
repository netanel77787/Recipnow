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
    let sourceName: String
    let id: Int
    let title: String
    let readyInMinutes: Int
    let sourceUrl: String
    let image: String
    let summary: String
    let instructions: String
    
//    enum CodingKeys: String, CodingKey{
//        case
//
//
//    }
}

// TODO: make enum of CodingKey for id, title, sourceUrl, image, summary : like in SearchRecipes

