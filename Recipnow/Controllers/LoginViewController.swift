//
//  LoginViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 05/03/2022.
//

import UIKit

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!


    
    @IBOutlet weak var togglePasswordLabel: UILabel!
    
    @IBAction func showPasswordSwitch(_ sender: UISwitch) {
        passwordTextField.isSecureTextEntry = !sender.isOn
        
        togglePasswordLabel.text = sender.isOn ? "Hide Password" : "Show Password"
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard isEmailValid && isPasswordValid,
              let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        showProgress(title: "Signing you in")
        
        AppAuth.shared.login(email: email, password: password, callback: loginCallback(_:_:))
        

 
      
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.disableAutoFill()
        emailTextField.disableAutoFill()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: (UIImage(named: "dow3") ?? UIImage(named: "systemImage"))!)
    }
    

   

}
