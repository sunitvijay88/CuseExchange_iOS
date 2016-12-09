//
//  UserReg.swift
//  IdeaApp
//
//  Created by HEERA ANIL on 11/19/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import FirebaseAuth
class UserReg: NSObject {
//    var name: String
//    var mobile: String
//    var profile_pic: String?
//    var address: String?
//    //designated Intializer
//    init(name: String, email: String, mobile: String, profile_pic: String, address: String) {
//        self.name = name
//        self.mobile = mobile
//        self.profile_pic = profile_pic
//        self.address = address
//        super.init()
//    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValid(email: String, password: String, name: String, mobilenumber: String)->Bool{
        if email != "" && password != "" && name != "" && mobilenumber != "" && (isValidEmail(testStr: email)){
            return true
            }else{
            return false
        }
    }
}
