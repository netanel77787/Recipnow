//
//  UiViewController+extensions.swift
//  Recipnati
//
//  Created by Netanel Mantsoor on 05/03/2022.
//

import Foundation
import PKHUD
import UIKit

// protocol #1
protocol ShowHUD{}

extension ShowHUD{
    func showProgress(title: String, subtitle: String? = nil){
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    func showError(title: String, subtitle: String? = nil){
        HUD.flash(.labeledError(title: title, subtitle: subtitle), delay: 3)
    }
    
    func showLabel(title: String){
        HUD.flash(.label(title), delay: 1)
    }
    
    func showSuccess(title: String, subtitle: String? = nil){
        HUD.flash(.labeledSuccess(title: title, subtitle: subtitle), delay: 1)
    }
    
}


extension UIViewController: ShowHUD{}



// protocol #2
protocol UserValidation: ShowHUD{
    var emailTextField: UITextField!{get}
    var passwordTextField: UITextField!{get}
    
}

extension UserValidation{
 
    var isEmailValid: Bool{
        guard let email = emailTextField.text,
              !email.isEmpty,
              email.count > 6,
              email.contains("@")
        else {
            showLabel(title: "Email must not be empty")
            return false
              }
        
        return true
    }
    
    var isPasswordValid: Bool{
        guard let password = passwordTextField.text,
              !password.isEmpty,
              password.count > 5
        else {
            showLabel(title: "Password must contain at least 6 characters")
            return false
              }
        
        return true
    }
}

extension RegisterViewController: UserValidation{}
extension LoginViewController: UserValidation{}



