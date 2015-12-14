//
//  UserDetailViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 8/10/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class UserDetailViewController: UITableViewController, UITextFieldDelegate, DismissViewDelegate {

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
    
    var selection = 1
    var role = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        currentUser?["name"] = name.text
        currentUser?["studentId"] = stuID.text
        currentUser?["phone"] = mobile.text
        currentUser?["gender"] = gender.text
        currentUser?["email"] = email.text
        currentUser?["username"] = email.text
        currentUser?["course"] = course.text
        
        currentUser?["address"] = houseNo.text
        currentUser?["state"] = state.text
        currentUser?["city"] = city.text
        currentUser?["postcode"] = postcode.text
        
        currentUser?.saveEventually()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
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
        let currentUser = PFUser.currentUser()
        
        currentUser?["name"] = name.text
        currentUser?["studentId"] = stuID.text
        currentUser?["phone"] = mobile.text
        currentUser?["gender"] = gender.text
        currentUser?["email"] = email.text
        currentUser?["username"] = email.text
        currentUser?["course"] = course.text
        
        currentUser?["role"] = role
        currentUser?["approve"] = "no"
        
        currentUser?.saveEventually()
        
        if gender.text == "M" || gender.text == "F" {
            self.performSegueWithIdentifier("detailToInterest", sender: self)
        } else {
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
            interestScene.dismissDelegate = self
        }
    }

}
