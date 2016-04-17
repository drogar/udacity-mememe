//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Brett Giles on 2016-04-04.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    // MARK: - View Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // Mark: - Meme Collection

    func addMeme(){
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeMeEditorViewController
        presentViewController(controller, animated: true, completion: nil)
    }

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // MARK: - Table view overrides
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard?.instantiateViewControllerWithIdentifier("MemeMeDetailViewController") as! MemeMeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as UITableViewCell!
        cell.detailTextLabel!.font = cell.textLabel!.font
        let meme = memes[indexPath.row]
        cell.textLabel!.text = meme.topText
        cell.detailTextLabel!.text = meme.bottomText
        cell.imageView?.image = meme.image
        
        return cell
    }
}
