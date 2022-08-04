//
//  SearchRecipes.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 09/03/2022.



import Foundation

struct SearchRecipes: Decodable{
    let searchResults: [Results]
}

struct Results: Decodable{
    let results: [SRecipe]
}

struct SRecipe: Decodable{
    let id: Int?
    let name: String?
    var isFavorite: Bool?
    let image: String?
    let link: String?
    let content: String?
}

