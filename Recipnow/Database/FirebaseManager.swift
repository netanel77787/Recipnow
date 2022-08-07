//
//  FirebaseManager.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 08/03/2022.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FirebaseManager{
    static let favoritesRef = Database.database().reference(withPath: "Favorites")
    
    enum DBError:Error {
        case userNotFound(Error?)
        case observerFailed(Error?)
        case noData(Error?)
    }
    
    enum FavoritesCategory : String {
        case search = "Search"
        case random = "Random"
    }
    
    // gets all the user favorites from db
    static func getUserFavorites(callback: @escaping ((random:[Favorite],search:[Favorite])?,Error?)->Void){
        guard let user = Auth.auth().currentUser else {
            callback(nil,DBError.userNotFound(nil))
            return
            
        }
        favoritesRef.child(user.uid).getData(completion: { err, snap in
            
            if !snap.exists() {
                callback(nil,DBError.noData(nil))
                return
            }
            let dict = snap.value as! [String:Any]
            let userFavoritesRandom = dict["Random"] as? [String:Any]
            let userFavoritesSearch = dict["Search"] as? [String:Any]
            
            var rand = [Favorite]()
            var search = [Favorite]()
            if let userFavoritesRandom = userFavoritesRandom {
                for k in userFavoritesRandom.values {
                    rand.append(Favorite.init(dict: k as! [String:Any])!)
                }
            }
            if let userFavoritesSearch = userFavoritesSearch {
                for k in userFavoritesSearch.values {
                    search.append(Favorite.init(dict: k as! [String:Any])!)
                }
            }
            
            callback((rand,search),nil)
        })
        
    }
    
    
    // adds a favorite to user's favoire
    static func addToUserFavorites(category:FavoritesCategory,favorite: Favorite, callback: @escaping (String?, Error?)->Void){
        guard let user = Auth.auth().currentUser else {
            callback(nil,DBError.userNotFound(nil))
            return
        }
        favorite.category = category.rawValue
        let userFavoritesRef = favoritesRef.child(user.uid)
            .child(category.rawValue)
            .child(String(favorite.recipeID))
        userFavoritesRef.setValue(favorite.dict, withCompletionBlock: { err, newRef in
            callback("Successfully Saved to favorites",nil)
        })
    }
    
    // removes favorite from user favorite
    static func removeFromUserFavorites(category:FavoritesCategory,favorite: Favorite, callback: @escaping (String?, Error?)->Void){
        guard let user = Auth.auth().currentUser else {
            callback(nil,DBError.userNotFound(nil))
            return
        }
        
        let userFavoritesRef = favoritesRef
            .child(user.uid)
            .child(favorite.category)
            .child(String(favorite.recipeID))
        print("Category : \(category.rawValue)")
        print("user : \(user.uid)")
        print("recipeid : \(String(favorite.recipeID))")
        userFavoritesRef.removeValue(completionBlock: { err, ref in
            callback("Successfully removed favorite item", err)
        })
    }
    
}
