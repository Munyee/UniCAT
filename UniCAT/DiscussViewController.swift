//
//  DiscussViewController.swift
//  UniCAT
//
//  Created by Munyee on 21/03/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class DiscussViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var userProfile: PFImageView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var userView: UIView!
    
    let currentUser = PFUser.currentUser()
    var keyboardHeight = CGFloat()
    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(true)

        keyboardHeight = 0.0
        
        comment.text = "Write Here"
        comment.textColor = UIColor.lightGrayColor()
        comment.delegate = self
        if (PFUser.currentUser() != nil){
            userProfile.file = currentUser!["image"] as? PFFile
            userProfile.loadInBackground()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func upload(sender: AnyObject) {
        
        if (PFUser.currentUser() == nil){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController")
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if comment.textColor == UIColor.lightGrayColor() {
            comment.text = nil
            comment.textColor = UIColor.blackColor()
        }
        
        
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if comment.text.isEmpty {
            comment.text = "Placeholder"
            comment.textColor = UIColor.lightGrayColor()
        }

    }
    
   
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height - 30
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
