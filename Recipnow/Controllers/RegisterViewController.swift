//
//  RegisterViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 05/03/2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var togglePasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.disableAutoFill()
        emailTextField.disableAutoFill()
    }
    
    @IBAction func showPasswordSwitch(_ sender: UISwitch) {
        passwordTextField.isSecureTextEntry = !sender.isOn
        togglePasswordLabel.text = sender.isOn ? "Hide Password" : "Show Password"
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard isEmailValid && isPasswordValid,
              let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        showProgress(title: "Signing up")
        
        AppAuth.shared.register(email: email, password: password, callback: registerCallback(_:_:))
        
//        if Router.shared.isUserLoggedIn == true{
//        showSuccess(title: "User added successfully")
//        }
//
        
    }
    
    
    

}

