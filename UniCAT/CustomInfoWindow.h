//
//  CustomInfoWindow.h
//  UniCAT
//
//  Created by Munyee on 12/12/2015.
//  Copyright © 2015 Sweatshop Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface CustomInfoWindow : UIView

@property (weak, nonatomic) IBOutlet PFImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
