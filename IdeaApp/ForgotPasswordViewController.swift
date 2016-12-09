//
//  ForgotPasswordViewController.swift
//  IdeaApp
//
//  Created by HEERA ANIL on 12/1/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import FirebaseAuth
class ForgotPasswordViewController : UIViewController{
    
    @IBOutlet var inputemail: UITextField!
    @IBAction func forgotButton(_ sender: UIButton) {
        let email = inputemail.text!
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            var title = ""
            var message = ""
            
            if error != nil{
                title = "Oops!"
                message = (error?.localizedDescription)!
            }else{
                title = "Success!"
                message = "Password reset email sent."
                self.inputemail.text = ""
            }
            
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK",
                                       style: .cancel ,
                                       handler: { (action) -> Void in
                                        self.dismiss(animated: true, completion: nil)
            })
            ac.addAction(action)
            self.present(ac, animated: true, completion: nil)
        })
    }
    
    @IBAction func onBackgroundTap(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        view.resignFirstResponder()
    }
    
}
