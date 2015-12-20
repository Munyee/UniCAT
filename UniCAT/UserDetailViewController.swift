//
//  UserDetailViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 8/10/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

protocol DismissViewDelegate {
    func dismissView()
}


class UserDetailViewController: UITableViewController, UITextFieldDelegate, DismissViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,RSKImageCropViewControllerDelegate {

    @IBOutlet weak var progreeBar: MBCircularProgressBarView!
    @IBOutlet weak var userProfile: PFImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var stuID: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var houseNo: UITextField!
    @IBOutlet weak var postcode: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var course: UITextField!
    
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var role1: UIButton!
    @IBOutlet weak var role2: UIButton!
    @IBOutlet weak var role3: UIButton!
    
    let picker = UIImagePickerController()
    var imageFile = PFFile!()
    var newImage = false
    
    var selection = 1
    var role = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.picker.delegate = self
        self.userProfile.layer.cornerRadius = self.userProfile.frame.size.width / 2;
        self.userProfile.layer.borderWidth = 1.0
        self.userProfile.layer.borderColor = UIColor.blackColor().CGColor
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "User Details"
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        name.resignFirstResponder()
        name.delegate = self
        
        stuID.resignFirstResponder()
        stuID.delegate = self
        
        mobile.resignFirstResponder()
        mobile.delegate = self
        
        gender.resignFirstResponder()
        gender.delegate = self
        
        email.resignFirstResponder()
        email.delegate = self
        
        course.resignFirstResponder()
        course.delegate = self
        
        if selection == 1 {
            houseNo.resignFirstResponder()
            houseNo.delegate = self
            
            state.resignFirstResponder()
            state.delegate = self
            
            city.resignFirstResponder()
            city.delegate = self
            
            postcode.resignFirstResponder()
            postcode.delegate = self
            
            let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveInfo:")
            self.navigationItem.rightBarButtonItem = saveButton
        } else {
            let skipButton : UIBarButtonItem = UIBarButtonItem(title: "Skip", style: UIBarButtonItemStyle.Plain, target: self, action: "skip:")
            self.navigationItem.rightBarButtonItem = skipButton
            
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let currentUser = PFUser.currentUser()
        
        userProfile.file = currentUser?["image"] as? PFFile
        userProfile.loadInBackground()
        name.text = currentUser?["name"] as? String
        stuID.text = currentUser?["studentId"] as? String
        mobile.text = currentUser?["phone"] as? String
        gender.text = currentUser?["gender"] as? String
        email.text = currentUser?["email"] as? String
        course.text = currentUser?["course"] as? String
        
        if selection == 1 {
            houseNo.text = currentUser?["address"] as? String
            state.text = currentUser?["state"] as? String
            city.text = currentUser?["city"] as? String
            postcode.text = currentUser?["postcode"] as? String
            
            if state.text == "" {
                state.text = "Perak"
            }
            
            if city.text == "" {
                city.text = "Kampar"
            }
            
            if postcode.text == "" {
                postcode.text = "31900"
            }
            
            switch currentUser?["role"] as! String {
            case "1":
                roleLabel.text = "Staff / Student"
            case "2":
                roleLabel.text = "Visitor / Parents"
            case "3":
                if currentUser?["approve"] as? String == "yes" {
                    roleLabel.text = "Event Planner"
                } else {
                    roleLabel.text = "Event Planner (Unverified)"
                }
            default:
                roleLabel.text = "Invalid Role"
            }
        }
    }
    
    func saveInfo(sender:UIButton) {
        let currentUser = PFUser.currentUser()
        
        
        let cancelButton : UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelInfo:")
        self.navigationItem.rightBarButtonItem = cancelButton
        
        
        if newImage {
            newImage = false
            let imageData = UIImageJPEGRepresentation(userProfile.image!, 0.5)
            imageFile = PFFile(name: "profile.jpg", data: imageData!)!
            
            imageFile.saveInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                // Handle success or failure here ...
                if succeeded {
                    print("Success")
                    currentUser?["image"] = self.imageFile
                    currentUser?["name"] = self.name.text
                    currentUser?["studentId"] = self.stuID.text
                    currentUser?["phone"] = self.mobile.text
                    currentUser?["gender"] = self.gender.text
                    currentUser?["email"] = self.email.text
                    currentUser?["username"] = self.email.text
                    currentUser?["course"] = self.course.text
                    
                    currentUser?["address"] = self.houseNo.text
                    currentUser?["state"] = self.state.text
                    currentUser?["city"] = self.city.text
                    currentUser?["postcode"] = self.postcode.text
                    currentUser?.saveEventually()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                }, progressBlock: {
                    
                    (percentDone: Int32) -> Void in
                    print(percentDone)
                    self.progreeBar.setValue(CGFloat(percentDone), animateWithDuration: 0.5)
                    
            })
        }else{
            
            currentUser?["name"] = self.name.text
            currentUser?["studentId"] = self.stuID.text
            currentUser?["phone"] = self.mobile.text
            currentUser?["gender"] = self.gender.text
            currentUser?["email"] = self.email.text
            currentUser?["username"] = self.email.text
            currentUser?["course"] = self.course.text
            
            currentUser?["address"] = self.houseNo.text
            currentUser?["state"] = self.state.text
            currentUser?["city"] = self.city.text
            currentUser?["postcode"] = self.postcode.text
            currentUser?.saveEventually()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func cancelInfo(sender:UIButton){
        imageFile.cancel()
        
        newImage = false
        
        let currentUser = PFUser.currentUser()
        
        userProfile.file = currentUser?["image"] as? PFFile
        userProfile.loadInBackground()
        name.text = currentUser?["name"] as? String
        stuID.text = currentUser?["studentId"] as? String
        mobile.text = currentUser?["phone"] as? String
        gender.text = currentUser?["gender"] as? String
        email.text = currentUser?["email"] as? String
        course.text = currentUser?["course"] as? String
        
        if selection == 1 {
            houseNo.text = currentUser?["address"] as? String
            state.text = currentUser?["state"] as? String
            city.text = currentUser?["city"] as? String
            postcode.text = currentUser?["postcode"] as? String
            
            if state.text == "" {
                state.text = "Perak"
            }
            
            if city.text == "" {
                city.text = "Kampar"
            }
            
            if postcode.text == "" {
                postcode.text = "31900"
            }
            
            switch currentUser?["role"] as! String {
            case "1":
                roleLabel.text = "Staff / Student"
            case "2":
                roleLabel.text = "Visitor / Parents"
            case "3":
                if currentUser?["approve"] as? String == "yes" {
                    roleLabel.text = "Event Planner"
                } else {
                    roleLabel.text = "Event Planner (Unverified)"
                }
            default:
                roleLabel.text = "Invalid Role"
            }
            
            self.progreeBar.setValue(0, animateWithDuration: 0.5)
            
            let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveInfo:")
            self.navigationItem.rightBarButtonItem = saveButton
            
        }

    }
    
    
    func skip(sender:UIButton) {
        let currentUser = PFUser.currentUser()
        currentUser?["gender"] = "U"
        currentUser?["role"] = "2"
        currentUser?.saveEventually()
        
        self.performSegueWithIdentifier("detailToInterest", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    
    @IBAction func roleButton(sender: AnyObject) {
        switch sender.tag {
        case 1:
            role1.selected = true
            role2.selected = false
            role3.selected = false
            role = "1"
        case 2:
            role1.selected = false
            role2.selected = true
            role3.selected = false
            role = "2"
        case 3:
            role1.selected = false
            role2.selected = false
            role3.selected = true
            role = "3"
        default:
            role1.selected = false
            role2.selected = false
            role3.selected = false
        }
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        
        
        if (newImage){
            let currentUser = PFUser.currentUser()
            let imageData = UIImageJPEGRepresentation(userProfile.image!, 0.5)
            imageFile = PFFile(name:"profile.jpg", data:imageData!)
            
            imageFile.saveInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                // Handle success or failure here ...
                if succeeded {
                    print("Success")
                    currentUser?["image"] = self.imageFile
                    currentUser?["name"] = self.name.text
                    currentUser?["studentId"] = self.stuID.text
                    currentUser?["phone"] = self.mobile.text
                    currentUser?["gender"] = self.gender.text
                    currentUser?["email"] = self.email.text
                    currentUser?["username"] = self.email.text
                    currentUser?["course"] = self.course.text
                    currentUser?["role"] = self.role
                    currentUser?["approve"] = "no"
                    currentUser?.saveEventually()
                }
                }, progressBlock: {
                    
                    (percentDone: Int32) -> Void in
                    print(percentDone)
                    
            })
        }
        else{
            let currentUser = PFUser.currentUser()
            let image = UIImage(named: "Logo")
            let imageData = UIImageJPEGRepresentation(image!, 0.5)
            imageFile = PFFile(name:"profile.jpg", data:imageData!)
            imageFile.saveInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                // Handle success or failure here ...
                if succeeded {
                    print("Success")
                    currentUser?["image"] = self.imageFile
                    currentUser?["name"] = self.name.text
                    currentUser?["studentId"] = self.stuID.text
                    currentUser?["phone"] = self.mobile.text
                    currentUser?["gender"] = self.gender.text
                    currentUser?["email"] = self.email.text
                    currentUser?["username"] = self.email.text
                    currentUser?["course"] = self.course.text
                    currentUser?["role"] = self.role
                    currentUser?["approve"] = "no"
                    
                    currentUser?.saveEventually()

                }
                }, progressBlock: {
                    
                    (percentDone: Int32) -> Void in
                    print(percentDone)                    
            })
        }
        
        
        
        
        if gender.text == "M" || gender.text == "F" && name.text != "" {
            self.performSegueWithIdentifier("detailToInterest", sender: self)
        }
        else if name.text == "" {
            name.backgroundColor = UIColor(red: 224/255.0, green: 72/255.0, blue: 81/255.0, alpha: 1.0)
            name.textColor = UIColor.whiteColor()
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        }
        else {
            gender.backgroundColor = UIColor(red: 224/255.0, green: 72/255.0, blue: 81/255.0, alpha: 1.0)
            gender.textColor = UIColor.whiteColor()
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if selection == 1 {
            switch textField {
            case name:
                stuID.becomeFirstResponder()
            case stuID:
                course.becomeFirstResponder()
            case course:
                mobile.becomeFirstResponder()
            case mobile:
                gender.becomeFirstResponder()
            case gender:
                if gender.text == "M" || gender.text == "F" {
                    email.becomeFirstResponder()
                }
            case email:
                houseNo.becomeFirstResponder()
            case houseNo:
                postcode.becomeFirstResponder()
            case postcode:
                city.becomeFirstResponder()
            case city:
                state.becomeFirstResponder()
            case state:
                dismissKeyboard()
            default:
                name.becomeFirstResponder()
            }
        } else {
            switch textField {
            case name:
                stuID.becomeFirstResponder()
            case stuID:
                course.becomeFirstResponder()
            case course:
                mobile.becomeFirstResponder()
            case mobile:
                gender.becomeFirstResponder()
            case gender:
                if gender.text == "M" || gender.text == "F" {
                    email.becomeFirstResponder()
                }
            case email:
                dismissKeyboard()
            default:
                name.becomeFirstResponder()
            }
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detailToInterest" {
            let interestScene = segue.destinationViewController as! ChooseInterestViewController
            interestScene.type = 2
            interestScene.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage

        let imageCropVC = RSKImageCropViewController.init(image: image, cropMode: RSKImageCropMode.Square)
        imageCropVC.delegate = self
        imageCropVC.navigationItem.hidesBackButton = true
        self.picker.pushViewController(imageCropVC, animated: true)
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.picker .dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.userProfile.image = croppedImage;
        newImage = true
        
        
    }
    
    
    
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Launch Camera")
            
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.cameraCaptureMode = .Photo
            self.presentViewController(self.picker, animated: true, completion: nil)
            
        })
        
        let libraryAction = UIAlertAction(title: "Choose Photo", style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            print("Open Photos Library")
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
            print("Cancelled")
        })
        
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

}
