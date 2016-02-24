//
//  MemeMeEditorViewController.swift
//  MemeMe
//
//  Created by Brett Giles on 2016-01-31.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit

class MemeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var keyboardAdjustment = CGFloat(0.0);
    
    var activeField: UITextField?
    
    
    @IBOutlet weak var memeContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var memeImage: UIImageView!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    ]
    
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        subscribeToKeyboardNotifications()
        
        print("appearing at size: Height: ", view.frame.size.height, "x Width:", view.frame.size.width)
        memeContainerHeight.constant = view.frame.size.height - toolbar.frame.height - navbar.frame.height
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("Transitioning to size: Height: ", size.height, "x Width:", size.width)
        coordinator.animateAlongsideTransition(nil, completion: { (context:UIViewControllerTransitionCoordinatorContext) -> Void in
            print("Transitioned: putting memeimageheight to ", size.height - self.toolbar.frame.height)
            self.memeContainerHeight.constant = size.height - self.toolbar.frame.height - self.navbar.frame.height
        })
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    // MARK: - IBActions

    @IBAction func pickAnImageFromPhotoLibrary(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeImage.image = nil
    }
    // MARK: - Generate Image
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(scrollView.frame.size)
        view.drawViewHierarchyInRect(scrollView.frame,
            afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            memeImage.image = image
        } else if let imagePhoto = info[UIImagePickerControllerLivePhoto] as? UIImage{
            memeImage.image = imagePhoto
        }
        else if let imageOriginal = info[UIImagePickerControllerOriginalImage] as? UIImage{
            memeImage.image = imageOriginal
        }
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topTextField && textField.text! == "TOP" {
            textField.text = ""
        }

        if textField == bottomTextField && textField.text! == "BOTTOM" {
            textField.text = ""
        }
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == topTextField && textField.text == "" {
            textField.text = "TOP"
        }
        
        if textField == bottomTextField && textField.text! == "" {
            textField.text = "BOTTOM"
        }
        activeField = nil
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - Keyboard notifications
    func keyboardWillShow(notification: NSNotification){
        if keyboardAdjustment == 0.0 {
            print("showing, -= keyboard height: ", getKeyboardHeight(notification))
            keyboardAdjustment = getKeyboardHeight(notification)
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardAdjustment, 0.0)
            scrollView.scrollEnabled = true
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            var aRect = scrollView.frame
            aRect.size.height -= keyboardAdjustment
            if let activeFieldPresent = activeField {
                if !CGRectContainsPoint(aRect, activeFieldPresent.frame.origin) {
                    scrollView.scrollRectToVisible(activeFieldPresent.frame, animated: true)
                }
            }
        } else {
            print("got show notification, already showing")
        }
    }

    func keyboardWillHide(notification: NSNotification){
        if keyboardAdjustment > 0.0 {
            print("hiding += adjustment (kb height):", keyboardAdjustment, getKeyboardHeight(notification) )
            let contentInsets = UIEdgeInsetsZero
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            scrollView.scrollEnabled = false
            scrollView.frame.size.height += keyboardAdjustment
            keyboardAdjustment = CGFloat(0.0)
        } else {
            print("Got hide notification, already hidden")
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
}

