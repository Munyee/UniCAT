//
//  TCMapViewController.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/17/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Bolts/Bolts.h>

/**
 * View Controller to display the Google Maps view.
 */
@interface TCMapViewController : UIViewController <GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *current;
@property (weak, nonatomic) IBOutlet UIImageView *direction;

@property (strong, nonatomic) UIImage* staticimage;

@property (strong, nonatomic) CLLocation *location;
/**
 * Marks the user's current location on the map view and get the place's details
 * with the given place reference string.
 *
 * @param myLocation     the user's current location
 * @param placeReference the place reference string to retrieve the place's details
 */
- (void)setMyLocation:(CLLocation *)myLocation placeReference:(NSString *)placeReference;

@end
