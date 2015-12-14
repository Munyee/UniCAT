//
//  TCCellModel.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/13/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCCellModel.h"

@implementation TCCellModel

- (id)initWithText:(NSString *)text detailText:(NSString *)detailText image:(UIImage *)image location:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
        _text = [text copy];
        _detailText = [detailText copy];
        _image = image;
        _location = location;
    }
    return self;
}

- (id)initWithText:(NSString *)text detailText:(NSString *)detailText image:(UIImage *)image
{
    self = [super init];
    if (self) {
        _text = [text copy];
        _detailText = [detailText copy];
        _image = image;
        
    }
    return self;
}

@end
