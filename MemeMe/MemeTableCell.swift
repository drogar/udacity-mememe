//
//  MemeTableCell.swift
//  MemeMe
//
//  Created by Brett Giles on 2016-04-04.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {
    
    
   @IBOutlet weak var memeImageView: UIImageView!
   @IBOutlet weak var topLabel: UILabel!
    
   @IBOutlet weak var bottomLabel: UILabel!
    
    func setText(topText: String, bottomText: String){
        topLabel.text = topText
        bottomLabel.text = bottomText
    }
}
