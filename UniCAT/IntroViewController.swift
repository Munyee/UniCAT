//
//  IntroViewController.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 8/19/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var introFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        let startup = NSUserDefaults.standardUserDefaults().boolForKey("firstStartup")
        let currentUser = PFUser.currentUser()
        
        if startup || currentUser != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            introFrame.fadeIn()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButton(sender: AnyObject) {
        introFrame.fadeOut()
        self.performSegueWithIdentifier("introToLogin", sender: self)
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
