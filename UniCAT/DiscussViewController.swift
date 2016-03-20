//
//  DiscussViewController.swift
//  UniCAT
//
//  Created by Munyee on 21/03/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class DiscussViewController: UIViewController {

    @IBOutlet weak var userProfile: PFImageView!
    @IBOutlet weak var comment: UITextView!
    
    let currentUser = PFUser.currentUser()
    
    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(true)

        comment.text = "Write Here"
        comment.textColor = UIColor.lightGrayColor()
        
        if (PFUser.currentUser() != nil){
            userProfile.file = currentUser!["image"] as? PFFile
            userProfile.loadInBackground()
        }
        
        
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
