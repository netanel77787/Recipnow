
//struct RandomRecipe: Decodable{
//    let recipes: [RRecipe]
//}
//struct RRecipe: Decodable{
//    let sourceName: String
//    let id: Int
//    let title: String
//    let readyInMinutes: Int
//    let sourceUrl: String
//    let image: String
//    let summary: String
//    let instructions: String
//}

import Foundation

struct SearchRecipes: Decodable{
    let searchResults: [Results]
}

struct Results: Decodable{
    let results: [SRecipe]
}

struct SRecipe: Decodable{
    let id: Int
    let name: String
    let imaage: String
    let link: String
    let content: String
}

//
//  SearchRecipes.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 09/03/2022.
