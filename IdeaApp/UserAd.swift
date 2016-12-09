//
//  UserAd.swift
//  IdeaApp
//
//  Created by HEERA ANIL on 11/26/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit

class UserAd: NSObject {
var category: String
var descrip: String?
var price: Int
//var subCategory: String
var title: String
var date: Date
    
    init(category: String, descrip: String?, price: Int, title: String) {
        self.category = category
        self.descrip = descrip
        self.price = price
        self.title = title
        self.date = Date()
        super.init()
    }
    

    
}
