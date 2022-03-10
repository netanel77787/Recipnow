//
//  FireAuth.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 08/03/2022.
//

import Foundation
import FirebaseAuth

class AppAuth{
    static let shared = AppAuth()
    private init(){}
    
    func login(email: String, password: String, callback: FireAuthCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: callback)
    }
    
    func register(email: String, password: String, callback: FireAuthCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: callback)
    }
    
    func signOut(){
        try? Auth.auth().signOut()
        Router.shared.determineRootViewController()
    }
}

typealias FireAuthCallback = ((AuthDataResult?, Error?)->Void)?
