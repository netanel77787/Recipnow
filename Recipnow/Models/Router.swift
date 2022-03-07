//
//  Router.swift
//  Recipnati
//
//  Created by Netanel Mantsoor on 05/03/2022.
//

import Foundation
import UIKit
import FirebaseAuth


class Router{
    static let shared = Router()
    
    private init(){}
    
    var isUserLoggedIn: Bool{
        Auth.auth().currentUser != nil
    }
    
    func determineRootViewController(){
        guard Thread.current.isMainThread else{
            DispatchQueue.main.async {[weak self] in
                self?.determineRootViewController()
            }
            return
        }
        
        let fileName = isUserLoggedIn ? "Main" : "Login"
        
        let sb = UIStoryboard(name: fileName, bundle: .main)
        
        let vc = sb.instantiateInitialViewController()
        
        window?.rootViewController = vc
    }
    
    weak var window: UIWindow?{
        didSet{
            determineRootViewController()
        }
    }
    
    
    
    
    
}
