//
//  ItemCell.swift
//  ItemCell
//
//  Created by HEERA ANIL on 11/22/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit

//ItemCell is a custom cell
class ItemCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!

    @IBOutlet var imageTest: UIImageView!
    //function to set fonts of labels
    func updateLabels() {
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
        
        let captionFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        serialNumberLabel.font = captionFont
    }
}
