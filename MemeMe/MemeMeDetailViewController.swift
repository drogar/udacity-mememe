//
//  MemeMeDetailViewController.swift
//  MemeMe
//
//  Created by Brett Giles on 2016-04-10.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {
    var meme: Meme?
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        if let m = meme{
            memeImageView.image = m.memedImage
        }
    }
    
}