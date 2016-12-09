//
//  LoginViewController.swift
//  IdeaApp
//
//  Created by HEERA ANIL on 11/30/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginViewController : UIViewController{
    
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let username = self.userNameField.text!
        let password = self.passwordField.text!
        
        if username != "" && password != "" {
            FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: {(user, error) in
                if error == nil{
                    AdStore.userInfo = FIRAuth.auth()?.currentUser
                    self.performSegue(withIdentifier: "mainView", sender: nil)
                }else{
                    let ac = UIAlertController(title: "Error",
                                               message: error?.localizedDescription,
                                               preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK",
                                               style: .default ,
                                               handler: nil)
                    ac.addAction(action)
                    
                    self.present(ac, animated: true, completion: nil)
                    self.userNameField.text! = ""
                    self.passwordField.text! = ""
                }
            })
        }else{
            if username == ""{
            self.userNameField.attributedPlaceholder = NSAttributedString(string: "Please enter email", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            if password == ""{
            self.passwordField.attributedPlaceholder = NSAttributedString(string: "Please enter password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
        }
        
    }
    
    @IBAction func onbackgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        view.resignFirstResponder()
    }
}
