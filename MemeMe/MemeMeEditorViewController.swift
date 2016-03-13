//
//  MemeMeEditorViewController.swift
//  MemeMe
//
//  Created by Brett Giles on 2016-01-31.
//  Copyright © 2016 Drogar Industries Ltd. All rights reserved.
//

import UIKit

class MemeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Variables and constant
    
    var keyboardAdjustment = CGFloat(0.0);
    
    var activeField: UITextField?
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    ]

    
    // MARK: - Outlets
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var memeContainer: UIView!
    @IBOutlet weak var memeContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
  
    
    // MARK: - View method overrides
   
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        actionButton.enabled = (memeImage.image != nil)
        
        initializeTextField(topTextField)
        initializeTextField(bottomTextField)
        
        subscribeToKeyboardNotifications()
        
        computeAndSetMemeContainerHeight(view.frame.size)
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(nil, completion: { (context:UIViewControllerTransitionCoordinatorContext) -> Void in
            self.computeAndSetMemeContainerHeight(size)
        })
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    

    // MARK: View method helper
    
    func computeAndSetMemeContainerHeight(size: CGSize) {
        memeContainerHeight.constant = size.height - toolbar.frame.height - navbar.frame.height
    }
    

    // MARK: - IBActions

    @IBAction func pickAnImageFromPhotoLibrary(sender: UIBarButtonItem) {
        presentImagePicker(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        presentImagePicker(.Camera)
    }
    
    
    @IBAction func reScaleImage(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            memeImage.contentMode = .ScaleToFill
        case 1:
            memeImage.contentMode = .ScaleAspectFit
        case 2:
            memeImage.contentMode = .ScaleAspectFill
        default:
            memeImage.contentMode = .ScaleToFill
        }
       
    }
    
    @IBAction func cancel(sender: AnyObject) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeImage.image = nil
        
        actionButton.enabled = false
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: memeImage.image!, memedImage: generateMemedImage())
        let viewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Generate Image
    
    func generateMemedImage() -> UIImage {
        //  Only draw the meme container, so no need to hide toolbar, navbar
        UIGraphicsBeginImageContext(memeContainer.frame.size)
        
        memeContainer.drawViewHierarchyInRect(memeContainer.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        
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
        
        enableOrDisableActionsAndDismiss()
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        enableOrDisableActionsAndDismiss()
    }
    
    func enableOrDisableActionsAndDismiss() {
        actionButton.enabled = (memeImage.image != nil)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: Image Picker method
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
 
        blankTextField(textField, whenEquals: topTextField, havingText: "TOP")
        blankTextField(textField, whenEquals: bottomTextField, havingText: "BOTTOM")

        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        resetBlankTextField(textField, whenEquals: topTextField, toText: "TOP")
        resetBlankTextField(textField, whenEquals: bottomTextField, toText: "BOTTOM")
 
        activeField = nil
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    // MARK: TextField methods
    
    func initializeTextField(textField: UITextField!) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
    func blankTextField(textField: UITextField, whenEquals: UITextField!, havingText: String) {
        if textField == whenEquals && textField.text! == havingText {
            textField.text = ""
        }
    }
    
    func resetBlankTextField(textField: UITextField, whenEquals: UITextField!, toText: String) {
        if textField == whenEquals && textField.text! == "" {
            textField.text = toText
        }
    }
    
    
    // MARK: - Keyboard Management
    
    // Changed how view is adjusted for keyboard notificatons. Using ScrollView as per 
    // https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
    
    func keyboardWillShow(notification: NSNotification){
        if keyboardAdjustment == 0.0 {
            keyboardAdjustment = getKeyboardHeight(notification)
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardAdjustment, 0.0)
            scrollView.scrollEnabled = true
            var scrollFrame = scrollView.frame
            
            adjustScrollInsets(contentInsets)
            
            scrollFrame.size.height -= keyboardAdjustment
            
            if let activeFieldPresent = activeField {
                if !CGRectContainsPoint(scrollFrame, activeFieldPresent.frame.origin) {
                    scrollView.scrollRectToVisible(activeFieldPresent.frame, animated: true)
                }
            }
            scrollView.scrollEnabled = false
        }
    }

    func keyboardWillHide(notification: NSNotification){
        if keyboardAdjustment > 0.0 {
            adjustScrollInsets(UIEdgeInsetsZero)
            scrollView.frame.size.height += keyboardAdjustment
            keyboardAdjustment = CGFloat(0.0)
        }
    }

    func adjustScrollInsets(newInsets: UIEdgeInsets) {
        scrollView.contentInset = newInsets
        scrollView.scrollIndicatorInsets = newInsets
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    // MARK: - Notifications
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

