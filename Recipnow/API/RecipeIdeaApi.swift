//
//  RecipeIdeaApi.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import Foundation
import Combine

struct RecipeIdeaApi{
    static let shared = RecipeIdeaApi()
    
    private init(){
        
    }

    var address = "https://api.spoonacular.com/recipes/complexSearch?apiKey=3bc51e3a93c44312b287363a0cae0d62&number=100"
    
    func requestIdeas()-> AnyPublisher<RecipeIdea?, URLError>{
        
        
        let url = URL(string: address)!
        
        
       return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main).map { result -> RecipeIdea? in
               let data = result.data
                return try? JSONDecoder().decode(RecipeIdea.self, from: data)
            }.eraseToAnyPublisher()
    }
}
