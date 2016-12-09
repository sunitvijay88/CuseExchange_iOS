//
//  TableViewCell.swift
//  IdeaApp
//
//  Created by HEERA ANIL on 12/4/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var NMItems: UILabel!
    
    @IBOutlet var imageTest: UIImageView!
    //function to set fonts of labels
    func updateLabels() {
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        NMItems.font = bodyFont
    }
}
