//
//  MapView.h
//  UniCAT
//
//  Created by Munyee on 3/7/15.
//  Copyright (c) 2015 Munyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapView : UIViewController <CLLocationManagerDelegate>
-(void)handlePinchWithGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer;
- (IBAction)buttonTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *blockA;
@property (strong, nonatomic) IBOutlet UIButton *blockB;
@property (strong, nonatomic) IBOutlet UIButton *blockC;
@property (strong, nonatomic) IBOutlet UIButton *blockD;


@end
