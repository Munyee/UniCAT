//
//  DemoAnnotationView.swift
//  Demo-Swift
//
//  Created by Yichi on 13/12/2014.
//  Copyright (c) 2014 Yichi Zhang. All rights reserved.
//

import UIKit

class DemoAnnotationView: JCAnnotationView {
	
	var imageView:UIView!
    var nibName:String = "MapPin"
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
        imageView = UIView()
		addSubview(imageView)
		
	}
	
	required init(coder aDecoder: NSCoder) {
		
		super.init(coder: aDecoder);
       
	}
	
	override func sizeThatFits(size: CGSize) -> CGSize {
		return CGSizeMake(max(imageView.frame.size.width,30), max(imageView.frame.size.height,30));
	}
   
    
	override func layoutSubviews() {
		
		imageView.sizeToFit();
		imageView.frame = imageView.bounds
	}
	
}
