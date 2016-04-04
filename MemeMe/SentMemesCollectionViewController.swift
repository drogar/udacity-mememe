//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Brett Giles on 2016-04-03.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController : UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView?.reloadData()
    }

    
    func addMeme(){
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeMeEditorViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // do somehting
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.item]
        cell.setText(meme.topText, bottomString: meme.bottomText)
        let imageView = UIImageView(image: meme.image)
        cell.backgroundView = imageView
        
        return cell
    }
}