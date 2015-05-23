//
//  DemoStyleKit.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 4/13/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
import UIKit

public class DemoStyleKit : NSObject {
    
    //// Cache
    
    private struct Cache {
        static var imageOfPDF: UIImage?
        static var pDFTargets: [AnyObject]?
        static var imageOfImage: UIImage?
        static var imageTargets: [AnyObject]?
    }
    
    //// Drawing Methods
    
    public class func drawPDF() {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Text Drawing
        let textRect = CGRectMake(0, 0, 25, 25)
        var textTextContent = NSString(string: "PDF")
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        
        let textFontAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: UIFont.systemFontSize())!, NSForegroundColorAttributeName: UIColor.blackColor(), NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = textTextContent.boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect);
        textTextContent.drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)
    }
    
    public class func drawImage() {
        
        //// Bezier 2 Drawing
        var bezier2Path = UIBezierPath()
        bezier2Path.moveToPoint(CGPointMake(9, 6))
        bezier2Path.addCurveToPoint(CGPointMake(8.54, 6.05), controlPoint1: CGPointMake(8.84, 6), controlPoint2: CGPointMake(8.68, 6.02))
        bezier2Path.addCurveToPoint(CGPointMake(7, 8), controlPoint1: CGPointMake(7.65, 6.26), controlPoint2: CGPointMake(7, 7.06))
        bezier2Path.addCurveToPoint(CGPointMake(9, 10), controlPoint1: CGPointMake(7, 9.1), controlPoint2: CGPointMake(7.9, 10))
        bezier2Path.addCurveToPoint(CGPointMake(11, 8), controlPoint1: CGPointMake(10.1, 10), controlPoint2: CGPointMake(11, 9.1))
        bezier2Path.addCurveToPoint(CGPointMake(9, 6), controlPoint1: CGPointMake(11, 6.9), controlPoint2: CGPointMake(10.1, 6))
        bezier2Path.closePath()
        bezier2Path.moveToPoint(CGPointMake(15.57, 11))
        bezier2Path.addCurveToPoint(CGPointMake(13.86, 14.59), controlPoint1: CGPointMake(15.57, 11), controlPoint2: CGPointMake(14.61, 13.02))
        bezier2Path.addCurveToPoint(CGPointMake(13, 16.4), controlPoint1: CGPointMake(13.39, 15.59), controlPoint2: CGPointMake(13, 16.4))
        bezier2Path.addCurveToPoint(CGPointMake(12.07, 15.43), controlPoint1: CGPointMake(13, 16.4), controlPoint2: CGPointMake(12.58, 15.95))
        bezier2Path.addCurveToPoint(CGPointMake(11.83, 15.18), controlPoint1: CGPointMake(11.99, 15.34), controlPoint2: CGPointMake(11.91, 15.26))
        bezier2Path.addCurveToPoint(CGPointMake(10.43, 13.7), controlPoint1: CGPointMake(11.15, 14.46), controlPoint2: CGPointMake(10.43, 13.7))
        bezier2Path.addLineToPoint(CGPointMake(7, 20))
        bezier2Path.addLineToPoint(CGPointMake(19, 20))
        bezier2Path.addLineToPoint(CGPointMake(15.57, 11))
        bezier2Path.closePath()
        bezier2Path.moveToPoint(CGPointMake(22, 3))
        bezier2Path.addCurveToPoint(CGPointMake(22, 22), controlPoint1: CGPointMake(22, 3), controlPoint2: CGPointMake(22, 22))
        bezier2Path.addLineToPoint(CGPointMake(3, 22))
        bezier2Path.addLineToPoint(CGPointMake(3, 3))
        bezier2Path.addLineToPoint(CGPointMake(22, 3))
        bezier2Path.addLineToPoint(CGPointMake(22, 3))
        bezier2Path.closePath()
        UIColor.blackColor().setFill()
        bezier2Path.fill()
    }
    
    //// Generated Images
    
    public class var imageOfPDF: UIImage {
        if Cache.imageOfPDF != nil {
            return Cache.imageOfPDF!
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(25, 25), false, 0)
        DemoStyleKit.drawPDF()
        
        Cache.imageOfPDF = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return Cache.imageOfPDF!
    }
    
    public class var imageOfImage: UIImage {
        if Cache.imageOfImage != nil {
            return Cache.imageOfImage!
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(25, 25), false, 0)
        DemoStyleKit.drawImage()
        
        Cache.imageOfImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return Cache.imageOfImage!
    }
    
    //// Customization Infrastructure
    
    @IBOutlet var pDFTargets: [AnyObject]! {
        get { return Cache.pDFTargets }
        set {
            Cache.pDFTargets = newValue
            for target: AnyObject in newValue {
                target.setImage(DemoStyleKit.imageOfPDF)
            }
        }
    }
    
    @IBOutlet var imageTargets: [AnyObject]! {
        get { return Cache.imageTargets }
        set {
            Cache.imageTargets = newValue
            for target: AnyObject in newValue {
                target.setImage(DemoStyleKit.imageOfImage)
            }
        }
    }
    
}

@objc protocol StyleKitSettableImage {
    func setImage(image: UIImage!)
}

@objc protocol StyleKitSettableSelectedImage {
    func setSelectedImage(image: UIImage!)
}
