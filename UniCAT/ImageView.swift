import UIKit
import AVFoundation


class ImageView: PFImageView
{
    let myGradientLayer: CAGradientLayer
    
    override init(frame: CGRect)
    {
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        myGradientLayer = CAGradientLayer()
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    
    
    func setup()
    {
        
        let color = image?.colorArt()
        let components = CGColorGetComponents(color?.backgroundColor.CGColor)
        
        let red = components[0];
        let green = components[1];
        let blue = components[2];
        
        myGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 0.8, y: 0)
        let colors: [CGColorRef] = [
            UIColor(red: red, green: green, blue: blue, alpha: 1).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.8).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.6).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.4).CGColor,
            UIColor(red: red, green: green, blue: blue, alpha: 0.2).CGColor,
            UIColor.clearColor().CGColor,
            UIColor.clearColor().CGColor,
            UIColor.clearColor().CGColor ]
        myGradientLayer.colors = colors
        myGradientLayer.opaque = false
        myGradientLayer.locations = [0.0,  0.3, 0.5, 0.7, 1.0]
        self.layer.addSublayer(myGradientLayer)
    }
    
    override func layoutSubviews()
    {
        myGradientLayer.frame = self.layer.bounds
    }
}


var aView = ImageView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))