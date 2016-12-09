//
//  Ad.swift
//  Ad
//
//  Created by HEERA ANIL on 11/21/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit

class Ad: NSObject {
    var name: String
    var valueInDollars: Int
    var desc: String?
    let dateCreated: Date
    var userEmail: String
    var category: String
    var adKey: String
    
    //designated Intializer
    init(name: String, valueInDollars: Int, desc: String?, category: String, adKey: String, userEmail : String) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.desc = desc
        self.category = category
        self.dateCreated = Date()
        self.adKey = adKey
        self.userEmail = userEmail
        
        super.init()
    }
    
}
