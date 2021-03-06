//
//  SOAnnotation.h
//  shoutout
//
//  Created by Mayank Jain on 9/3/15.
//  Copyright (c) 2015 Mayank Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTree.h"
#import <Parse/Parse.h>
@import MapKit;

@interface SOAnnotation : NSObject<MKAnnotation, QTreeInsertable>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *pinColor;
@property (assign, nonatomic) BOOL online;
@property (assign, nonatomic) BOOL isStatic;
@property (strong, nonatomic) PFObject *object;

-(id)initWithTitle:(NSString *)title Subtitle:(NSString *)subtitle Location:(CLLocationCoordinate2D)coordinate;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
