//
//  SearchRecipesApi.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import Foundation
import Combine

struct SearchRecipesApi{
 
    static let shared = SearchRecipesApi()
    
    private init(){
        
    }

  
    
    func requestSearch(query: String)-> AnyPublisher<SearchRecipes, Error>{
        
            let address = "https://api.spoonacular.com/food/search?query=\(query)&apiKey=0ca8b4c1463d4bc4b100d25ace36a764"
        
        let url = URL(string: address)!
        
        return  URLSession.shared.dataTaskPublisher(for: url).tryMap { data, res in
            return try JSONDecoder().decode(SearchRecipes.self, from: data)
        }.eraseToAnyPublisher()
        
      
    }
}
