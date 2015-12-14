//
//  SignUpInViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/18/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class SignUpInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signInToggle: UIButton!
    
    var toggle = true
    
    @IBAction func signInUpToggle(sender: AnyObject) {
        if toggle {
            signUpButton.hidden = false
            signInButton.hidden = true
            signInToggle.selected = true
        }
        
        if !toggle {
            signUpButton.hidden = true
            signInButton.hidden = false
            signInToggle.selected = false
        }
        
        toggle = !toggle
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        var userEmailAddress = emailAddress.text
        var userPassword = password.text
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress!.lowercaseString
        
        // Add email address validation
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // Create the user
        var user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("loginToSignup", sender: self)
                }
                
            } else {
                
                self.activityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo["error"] {
                    self.message.text = "\(message)"
                }				
            }
        }
    }
    
    @IBAction func signIn(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var userEmailAddress = emailAddress.text
        userEmailAddress = userEmailAddress!.lowercaseString
        
        var userPassword = password.text
        
        PFUser.logInWithUsernameInBackground(userEmailAddress!, password:userPassword!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    //self.performSegueWithIdentifier("signInToNavigation", sender: self)
                }
            } else {
                self.activityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo["error"] {
                    self.message.text = "\(message)"
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //super.touchesBegan(touches as Set<NSObject>, withEvent: event)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.hidden = true
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        emailAddress.resignFirstResponder()
        password.resignFirstResponder()
        
        emailAddress.delegate = self
        password.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleSignInUpButton(choice: Int) {
        if choice == 1 {
            signUpButton.hidden = true
            signInButton.hidden = false
        } else if choice == 2 {
            signUpButton.hidden = false
            signInButton.hidden = true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailAddress {
            self.password.becomeFirstResponder()
            /*
            // Check if user exists
            let backgroundQueue: dispatch_queue_t = dispatch_queue_create("com.a.identifier", DISPATCH_QUEUE_CONCURRENT)
            
            // can be called as often as needed
            dispatch_async(backgroundQueue) {
                
                var query = PFUser.query()
                query?.whereKey("username", equalTo: self.emailAddress.text)
                var usernameP = query?.getFirstObject()
                
                if usernameP != nil {
                    self.toggleSignInUpButton(1)
                } else {
                    self.toggleSignInUpButton(2)
                }
            }
            */
        } else if textField == self.password {
            
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            var userEmailAddress = emailAddress.text
            userEmailAddress = userEmailAddress!.lowercaseString
            
            var userPassword = password.text
            if toggle {
                PFUser.logInWithUsernameInBackground(userEmailAddress!, password:userPassword!) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    } else {
                        self.activityIndicator.stopAnimating()
                        
                        if let message: AnyObject = error!.userInfo["error"] {
                            self.message.text = "\(message)"
                        }
                    }
                }
            } else {
                // Create the user
                var user = PFUser()
                user.username = userEmailAddress
                user.password = userPassword
                user.email = userEmailAddress
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("loginToSignup", sender: self)
                        }
                        
                    } else {
                        
                        self.activityIndicator.stopAnimating()
                        
                        if let message: AnyObject = error!.userInfo["error"] {
                            self.message.text = "\(message)"
                        }				
                    }
                }
            }
            
        }
        
        return true
    }
    
    @IBAction func skipLogin(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstStartup")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "loginToSignup" {
            let nav = segue.destinationViewController as! UINavigationController
            let detailScene = nav.topViewController as! UserDetailViewController
            detailScene.selection = 2
        }
    }

}
