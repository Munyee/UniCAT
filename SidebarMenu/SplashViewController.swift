//
//  SplashViewController.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 4/3/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var logoY: NSLayoutConstraint!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var logoView: UIImageView!
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false;
        }
        else {
            return true;
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue) | Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.logoY.constant = 0
        userNameField.alpha = 0.0
        passwordField.alpha = 0.0
        loginButton.alpha = 0.0
        
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
        self.view.endEditing(true)
    }
    
    func viewUpdate() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.5
        animation.fromValue = NSValue(CGPoint: CGPointMake(logoView.center.x, logoView.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(logoView.center.x, logoView.center.y-130))
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        logoView.layer.addAnimation(animation, forKey: "position")
        
        UIView.animateWithDuration(0.3, delay: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.logoY.constant = 130
            }, completion: nil)
        
        userNameField.fadeIn(duration: 0.3, delay: 0.2)
        passwordField.fadeIn(duration: 0.3, delay: 0.2)
        loginButton.fadeIn(duration: 0.3, delay: 0.2)
    }
    
    @IBAction func loginScreen(sender: AnyObject) {
        viewUpdate()
        nextButton.fadeOut()
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