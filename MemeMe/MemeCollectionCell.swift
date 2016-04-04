//
//  MemeCollectionCell.swift
//  MemeMe
//
//  Created by Brett Giles on 2016-04-03.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit

class MemeCollectionCell: UICollectionViewCell {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func setText(topString: String, bottomString: String) {
        topLabel.text = topString
        bottomLabel.text = bottomString
    }
}
