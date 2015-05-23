//
//  UIViewExtensions.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 3/27/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(duration: NSTimeInterval = 0.3, delay: NSTimeInterval = 0.0) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)  }
    
    func fadeOut(duration: NSTimeInterval = 0.2, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
    
    func instaOut() {
        UIView.animateWithDuration(0.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
    
}

extension NSObject {
    
    func callSelectorAsync(selector: Selector, object: AnyObject?, delay: NSTimeInterval) -> NSTimer {
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: selector, userInfo: object, repeats: false)
        return timer
    }
    
    func callSelector(selector: Selector, object: AnyObject?, delay: NSTimeInterval) {
        
        let delay = delay * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(selector, toTarget:self, withObject: object)
        })
    }
}