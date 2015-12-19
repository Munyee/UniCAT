//
//  JPBFloatingTextViewController.h
//  Pods
//
//  Created by Joseph Pintozzi on 8/22/14.
//
//

#import "JPBParallaxTableViewController.h"
#import <ColorArt/UIImage+ColorArt.h>

@interface JPBFloatingTextViewController : JPBParallaxTableViewController

- (void)setTitleText:(NSString*)text;
- (void)setSubtitleText:(NSString*)text;
- (void)selLabelBackground:(UIColor*)color;
- (void)setLabelBackgroundGradientColor:(UIColor*)bottomColor;

- (void)setTitleColor:(UIColor*)color;
- (void)setSubtitleTextColor:(UIColor*)color;


- (CGFloat)horizontalOffset;

@property (nonatomic, strong) SLColorArt *color;

@end
