//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Brett Giles on 2016-04-04.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    

    func addMeme(){
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeMeEditorViewController
        //        controller.mc = self
        presentViewController(controller, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //display detail
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! MemeTableCell
        
        let meme = memes[indexPath.row]
        cell.setText(meme.topText, bottomText: meme.bottomText)
        cell.memeImageView.image = meme.image
        
        return cell
        
    }
}
