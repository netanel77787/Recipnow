//
//  RecipeIdea.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 09/03/2022.
//

import Foundation

struct RecipeIdea: Decodable{
    let results: [IRecipe]
}

struct IRecipe: Decodable{
    let id: Int
    let title: String
    let image: URL?
}
