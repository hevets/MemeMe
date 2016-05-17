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
        
        setupUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // check to see if the camera is available on the device
        captureButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // setup inital ui
        subscribeToKeyboardNotifications()
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
    
    // MARK: IBAction Events
    @IBAction func albumTapped(sender: AnyObject) {
        let album = UIImagePickerController()
        album.delegate = self
        presentViewController(album, animated: true, completion: nil)
    }
    
    @IBAction func captureTapped(sender: AnyObject) {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(camera, animated: true, completion: nil)
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
        
        let shareActivity = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        presentViewController(shareActivity, animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        setupUI()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // TODO: dont delete if text is TOP or BOTTOM
        if textField.text != "TOP" || textField.text != "BOTTOM" {
            textField.text = ""
        }
    }
    
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
    
    // MARK: UI methods
    func setupUI() {
        view.endEditing(true)
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.enabled = false
        cancelButton.enabled = false
        imageView.image = nil
        
        let memeAttr = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0
        ]
        
        topTextField.defaultTextAttributes = memeAttr
        bottomTextField.defaultTextAttributes = memeAttr
        topTextField.textAlignment = .Center
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
        if topTextField.text == "" {
            topTextField.text = "TOP"
        }
        
        if bottomTextField.text == "" {
            bottomTextField.text = "BOTTOM"
        }
        
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
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
}

