//
//  Favorite.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 09/04/2022.
//

import Foundation


class Favorite: FirebaseModel {
    let name: String
    let recipeID: Int
    let image: String
    let link: String
    let content: String
    var category: String = ""
    
    // add instructions & readyinminutes
    
    init(name: String, recipeID: Int, image: String, link: String, content: String){
        self.name = name
        self.recipeID = recipeID
        self.image = image
        
        self.link = link
        self.content = content
      
    }
   
    var dict: [String : Any]{
        let dict = ["name" : name, "recipeID" : recipeID, "image" : image, "link" : link, "content" : content, "category" : category] as [String : Any]
        return dict
    }
    
    required init?(dict: [String : Any]) {
        guard let name = dict["name"] as? String,
              let recipeID = dict["recipeID"] as? Int,
              let image = dict["image"] as? String,
              let link = dict["link"] as? String,
              let content = dict["content"] as? String,
              let category = dict["category"] as? String
        else {
            return nil
            
        }
        self.category = category
        self.name = name
        self.recipeID = recipeID
        self.image = image
        self.link = link
        self.content = content
    }
    
}
