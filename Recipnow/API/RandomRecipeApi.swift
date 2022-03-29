//
//  RandomRecipeApi.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 26/03/2022.
//

import Foundation

import Combine

struct RandomRecipeApi{
 
    static let shared = RandomRecipeApi()
    
    private init(){}

    let address = "https://api.spoonacular.com/recipes/random?number=1&apiKey=0ca8b4c1463d4bc4b100d25ace36a764"
    
    func randomRequest()-> AnyPublisher<RandomRecipe?, Error>{
        
        let url = URL(string: address)!
        
        return  URLSession.shared.dataTaskPublisher(for: url).tryMap { data, res in
            return try JSONDecoder().decode(RandomRecipe.self, from: data)
        }.eraseToAnyPublisher()
      
    }
}
