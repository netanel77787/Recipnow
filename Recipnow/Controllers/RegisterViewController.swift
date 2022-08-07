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
        self.view.backgroundColor = UIColor(patternImage: (UIImage(named: "dow3") ?? UIImage(named: "systemImage"))!)
        passwordTextField.disableAutoFill()
        emailTextField.disableAutoFill()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func showPasswordSwitch(_ sender: UISwitch) {
        passwordTextField.isSecureTextEntry = !sender.isOn
        togglePasswordLabel.text = sender.isOn ? "Hide Password" : "Show Password"
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard isEmailValid && isPasswordValid,
              let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        showProgress(title: "Signing up",subtitle: "Please remember your details")
        
        AppAuth.shared.register(email: email, password: password, callback: registerCallback(_:_:))
        
  
    }
    
    
    

}

