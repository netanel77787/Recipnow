//
//  FirebaseManager.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 08/03/2022.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

//struct Recipe {
//    
//    var x:String?
//    var y:String?
//    var z:Int?
//    
//    init (dict:[String:Any]) {
//        if let x = dict["x"] as? String {
//            self.x = x
//        }
//        if let y = dict["y"] as? String {
//            self.y = y
//        }
//        if let z = dict["z"] as? Int {
//            self.z = z
//        }
//    }
//    
//    init (x:String?,y:String?,z:Int?){
//        self.x = x
//        self.y = y
//        self.z = z
//    }
//    
//    func toDict() -> [String:Any] {
//        var dict = [String:Any]()
//        dict["x"] = self.x
//        dict["y"] = self.y
//        dict["z"] = self.z
//        return dict
//    }
//}
//
//class FirebaseManager  {
//    
//    static let shared: FirebaseManager = FirebaseManager()
//    private let favoritesPath:DatabaseReference = Database.database().reference(withPath: "Favorites")
//    private init() {}
//    
//    
//    func addFavoriteRecipe(recipe:Recipe) {
//        if let uid = Auth.auth().currentUser?.uid {
//            favoritesPath.child(uid).childByAutoId()
////                .setValue(recipe.toDict())
//        }
//    }
//    
//    func getFavorites(callback: @escaping ([Recipe]) -> Void) {
//        if let uid = Auth.auth().currentUser?.uid {
//            favoritesPath.child(uid).observeSingleEvent(of: .value) { snap in
//                var recipes = [Recipe]()
//                for child in snap.children {
//                    let childSnap = child as! DataSnapshot
//                    let dict = childSnap.value as! [String:Any]
////                    let r = Recipe(dict: dict)
////                    recipes.append(r)
//                }
//                callback(recipes)
//            }
//
//        }
//    }
//}
