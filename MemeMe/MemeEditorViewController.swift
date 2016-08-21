//
//  ViewController.swift
//  MemeMe
//
//  Created by Steve Henderson on 2016-05-16.
//  Copyright © 2016 Steve Henderson. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check to see if the camera is available on the device
        captureButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // setup inital ui
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Image Picker
    func pickImage(_ sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: IBAction Events
    @IBAction func albumTapped(_ sender: AnyObject) {
        pickImage(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    @IBAction func captureTapped(_ sender: AnyObject) {
        pickImage(UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction func displayExportOptions() {
        let menu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

        let saveAction = UIAlertAction(title: "Save", style: .default) { (alert: UIAlertAction!) in
            let memedImage = self.generateMemedImage()
            self.save(memedImage)
            self.dismiss(animated: true, completion: nil)
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { (alert: UIAlertAction!) in
            self.share()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert:UIAlertAction!) in
            print("cancelled")
        }

        menu.addAction(saveAction)
        menu.addAction(shareAction)
        menu.addAction(cancelAction)

        self.present(menu, animated: true, completion: nil)
    }

    @IBAction func cancelTapped(_ sender: AnyObject) {
        dismiss(animated: true) {
            self.resetUI()
        }
    }

    func share() {
        let memedImage = generateMemedImage()
        let shareActivity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareActivity.completionWithItemsHandler = { activityType, completed, items, error in
            self.save(memedImage)
            self.dismiss(animated: true, completion: nil)
        }
        present(shareActivity, animated: true, completion: nil)
    }

    func save(_ memedImage:UIImage) {
        //Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: memedImage)
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imagePicked()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func resetUI() {
        view.endEditing(true)
        shareButton.isEnabled = false
        cancelButton.isEnabled = true
        imageView.image = nil
        topTextField.text = ""
        bottomTextField.text = ""
    }
    
    // MARK: UI methods
    func setupUI() {
        resetUI()
        
        // setup textFields
        self.setupTextField(topTextField, bottomTextField)
        
        // register tap recognizer for detecting view taps (dismisses keyboard)
        let tap = UITapGestureRecognizer(target: self, action: #selector(MemeEditorViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupTextField(_ textFields:UITextField...) {
        for textField in textFields {
            let memeAttr = [
                NSStrokeColorAttributeName: UIColor.black,
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSStrokeWidthAttributeName: -3.0
            ] as [String : Any]
            
            textField.delegate = self
            textField.defaultTextAttributes = memeAttr
            textField.textAlignment = .center
        }
    }
    
    func imagePicked() {
        shareButton.isEnabled = true
        cancelButton.isEnabled = true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // generates a memed image
    func generateMemedImage() -> UIImage {
        // toolbars should be hidden to prevent it getting included in the image
        self.bottomToolBar.isHidden = true
        self.topToolBar.isHidden = true
        
        // create graphic by rendering image + text
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.bottomToolBar.isHidden = false
        self.topToolBar.isHidden = false
        
        return memedImage!
    }

    // MARK: Utility methods
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
}

