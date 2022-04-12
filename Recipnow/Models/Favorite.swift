//
//  Favorite.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 09/04/2022.
//

import Foundation


class Favorite: FirebaseModel{
    let id: String
    let name: String
    let recipeID: String
    let image: String
    let link: String
    let content: String
    
    // add instructions & readyinminutes
    
    init(name: String, recipeID: String, image: String, link: String, content: String ){
        self.id = UUID().uuidString
        self.name = name
        self.recipeID = recipeID
        self.image = image
        
        self.link = link
        self.content = content
      
    }
   
    var dict: [String : Any]{
        let dict = ["id" : id, "name" : name, "recipeID" : recipeID, "image" : image, "link" : link, "content" : content]
        return dict
    }
    
    required init?(dict: [String : Any]) {
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String,
              let recipeID = dict["recipeID"] as? String,
              let image = dict["image"] as? String,
              let link = dict["link"] as? String,
              let content = dict["content"] as? String
        else {
            return nil
            
        }
        
        self.id = id
        self.name = name
        self.recipeID = recipeID
        self.image = image
        self.link = link
        self.content = content
    }
    
}
