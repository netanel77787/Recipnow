//
//  UiViewController+extensions.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 05/03/2022.
//


import PKHUD
import UIKit
import FirebaseAuth

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

// protocol #2
protocol UserValidation: ShowHUD{
    var emailTextField: UITextField!{get}
    var passwordTextField: UITextField!{get}
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension UserValidation{
    
    var isEmailValid: Bool{
        guard let email = emailTextField.text,
              !email.isEmpty,
              email.contains("@")
        else {
            showLabel(title: "Email is not valid")
            return false
        }
        
        return true
    }
    
    var isPasswordValid: Bool{
        guard let password = passwordTextField.text,
              !password.isEmpty,
              password.count >= 6
        else {
            showLabel(title: "Password must contain at least 6 characters")
            return false
        }
        
        return true
    }
    
    func registerCallback(_ result: AuthDataResult?,_ err: Error?){
        
        if let err = err {
            showError(title: "Error", subtitle: "\(err.localizedDescription)")
            return
        }
        Router.shared.registerDetermineRootViewController()
        AppAuth.shared.signOut()
    }
    
    func loginCallback(_ result: AuthDataResult?,_ err: Error?){
        
        if let err = err {
            showError(title: "Error", subtitle: "\(err.localizedDescription)")
            return
        }
       
        Router.shared.loginDetermineRootViewController()
        
    }
    
}

// protocol #3
protocol SignOut{
    
}

extension SignOut{
    
}

extension UIViewController: SignOut{
    func signOut(){
        let action = UIAction { _ in
              AppAuth.shared.signOut()
          }

          let signOutBBI =  UIBarButtonItem(title: "Sign Out", image: UIImage(systemName: "homekit"), primaryAction: action, menu: .none)
        navigationItem.leftBarButtonItem = signOutBBI
    }
}


extension  UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}



extension UIViewController: ShowHUD{}

extension RegisterViewController: UserValidation{}
extension LoginViewController: UserValidation{}
