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
    
    @IBAction func showPasswordSwitch(_ sender: UISwitch) {
        passwordTextField.isSecureTextEntry = !sender.isOn
        togglePasswordLabel.text = sender.isOn ? "Hide Password" : "Show Password"
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard isEmailValid && isPasswordValid,
              let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        sender.isEnabled = false
        showProgress(title: "Signing you in")
        
        AppAuth.shared.register(email: email, password: password, callback: callback(_:_:))
    }
    
    
    

}

