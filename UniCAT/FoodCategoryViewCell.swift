//
//  FoodCategoryViewCell.swift
//  UniCAT
//
//  Created by Munyee on 19/12/2015.
//  Copyright © 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class FoodCategoryViewCell: PFCollectionViewCell {
    @IBOutlet weak var userImage: PFImageView!
    @IBOutlet weak var category: UILabel!
    let myGradientLayer: CAGradientLayer
    var count = 0
    
    override init(frame: CGRect)
    {
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
//        self.setup()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        myGradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)!
//        self.setup()
    }
    
    
    func setup(color : SLColorArt)
    {
        let components = CGColorGetComponents(color.backgroundColor.CGColor)
        
        let red = components[0];
        let green = components[1];
        let blue = components[2];
        
        myGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 0.75, y: 0)
        let colors: [CGColorRef] = [
            UIColor(red: red, green: green, blue: blue, alpha: 1).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.85).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.7).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.55).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.4).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.25).CGColor,
            UIColor.clearColor().CGColor,
            UIColor.clearColor().CGColor ]
        myGradientLayer.colors = colors
        myGradientLayer.opaque = false
        myGradientLayer.locations = [0.0,  0.3, 0.5, 0.7, 1.0]
        
        userImage.layer.addSublayer(myGradientLayer)
        
        count++
    }
    
    override func layoutSubviews()
    {
        myGradientLayer.frame = self.layer.bounds
    }
}