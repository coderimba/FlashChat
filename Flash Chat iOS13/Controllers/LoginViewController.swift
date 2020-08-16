//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                  //  print(e.localizedDescription) //can present the error to the user; refer to reference 'FIRAuthErrors' to see all the different error codes. Then, create a switch statement that checks for which one we are getting then turn the error codes to sth that is useful for the user
                    if let errorCode = AuthErrorCode(rawValue: e._code) {
                        switch errorCode {
                        case .invalidEmail:
                            self.errorLabel.text = "Invalid email. Try again."
                        case .wrongPassword:
                            self.errorLabel.text = "Wrong password. Try again."
                        case .userNotFound:
                            self.errorLabel.text = "User account was not found."
                        default:
                            self.errorLabel.text = "Unknown error."
                        }
                    }
                } else {
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
        
    }
    
}
