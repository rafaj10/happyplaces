//
//  FoursquareVenue.h
//  HappyPlaces
//
//  Created by Rafael Assis on 4/10/15.
//  Copyright (c) 2015 rafaiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareVenue : NSObject

@property (nonatomic,strong) NSString * venueId;
@property (nonatomic,strong) NSString * venueTitle;
@property (nonatomic,strong) NSNumber * lat;
@property (nonatomic,strong) NSNumber * lng;
@property (nonatomic,strong) NSString * url_icon;

- (id)initWithResponse:(id)response;

@end
