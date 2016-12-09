//
//  SignUpViewController.swift
//  IdeaApp
//
//  Created by HEERA ANIL on 11/30/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController : UIViewController,UITextViewDelegate{
    
    @IBOutlet var mobileNumberField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var nameField: UITextField!
    var ref: FIRDatabaseReference!
    var userReg = UserReg()
    override func viewDidLoad() {
        //fixed this please
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
    }

    @IBAction func onBackgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        view.resignFirstResponder()
    }
    
    @IBAction func onCreate(_ sender: UIButton) {
        //Getting values from fields
        let email = self.emailField.text!
        let password = self.passwordField.text!
        let name = self.nameField.text!
        let mobilenumber = self.mobileNumberField.text!
        if userReg.isValid(email: email,password: password,name: name,mobilenumber: mobilenumber) {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion:  { (user, error) in
                if error == nil{
                    FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            let newEmail = email.replacingOccurrences(of: ".", with: ",")
                    print ("\(newEmail)")
                    self.ref.child("users").child(newEmail).setValue(["mobile": mobilenumber, "name": name, "notifications": "Y", "profile_pic": ""])
                    let ac = UIAlertController(title: "Successfully Added",
                                               message: "User created!",
                                               preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK",
                                               style: .default ,
                                               handler: { (action) -> Void in
                                    self.dismiss(animated: true, completion: nil)
                        })
                    ac.addAction(action)
                    
                    self.present(ac, animated: true, completion: nil)
                }else{
                    let ac = UIAlertController(title: "Oops",
                                               message: error?.localizedDescription,
                                               preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK",
                                               style: .default ,
                                               handler: nil)
                    ac.addAction(action)
                    
                    self.present(ac, animated: true, completion: nil)
                    self.emailField.text! = ""
                    self.passwordField.text! = ""
                    self.mobileNumberField.text! = ""
                    self.nameField.text! = ""
                  
        }
            })
        }else{
            if (email == "" || !userReg.isValidEmail(testStr: email) )
            {
                self.emailField.text! = ""
                self.emailField.attributedPlaceholder = NSAttributedString(string: "Please enter valid email", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
           if password == ""{
                self.passwordField.attributedPlaceholder = NSAttributedString(string: "Please enter password", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            if mobilenumber == ""{
                self.mobileNumberField.attributedPlaceholder = NSAttributedString(string: "Please enter mobile", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            if name == ""{
                self.nameField.attributedPlaceholder = NSAttributedString(string: "Please enter name", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            }
}
}
