//
//  ViewController.swift
//  MemeMe
//
//  Created by Steve Henderson on 2016-05-16.
//  Copyright © 2016 Steve Henderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var captureButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // check to see if the camera is available on the device
        captureButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // setup inital ui
        subscribeToKeyboardNotifications()
        setupUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Image Picker
    func pickImage(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: IBAction Events
    @IBAction func albumTapped(sender: AnyObject) {
        pickImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func captureTapped(sender: AnyObject) {
        pickImage(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        let shareActivity = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
//        shareActivity.completionWithItemsHandler = {
//            (activityType, completed, _, _) in
//            if completed {
//                let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, image: self.imageView.image!, memedImage: self.generateMemedImage())
//                
//            }
//        }
        presentViewController(shareActivity, animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        resetUI()
    }
    
    // MARK: UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imagePicked()
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetUI() {
        view.endEditing(true)
        shareButton.enabled = false
        cancelButton.enabled = false
        imageView.image = nil
    }
    
    // MARK: UI methods
    func setupUI() {
        resetUI()
        
        let memeAttr = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        topTextField.defaultTextAttributes = memeAttr
        topTextField.textAlignment = .Center
        bottomTextField.defaultTextAttributes = memeAttr
        bottomTextField.textAlignment = .Center
        
        // register tap recognizer for detecting view taps (dismisses keyboard)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func imagePicked() {
        shareButton.enabled = true
        cancelButton.enabled = true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // generates a memed image
    func generateMemedImage() -> UIImage {
        // toolbars should be hidden to prevent it getting included in the image
        self.bottomToolBar.hidden = true
        self.topToolBar.hidden = true
        
        // create graphic by rendering image + text
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.bottomToolBar.hidden = false
        self.topToolBar.hidden = false
        
        return memedImage
    }
    
    // MARK: Utility methods
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
}

