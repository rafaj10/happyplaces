//
//  FoursquareVenue.m
//  HappyPlaces
//
//  Created by Rafael Assis on 4/10/15.
//  Copyright (c) 2015 rafaiOS. All rights reserved.
//

#import "FoursquareVenue.h"

@implementation FoursquareVenue

- (id)initWithResponse:(id)response{
    self = [super init];
    if (self) {
        _venueId = [response objectForKey:@"id"];
        _venueTitle = [response objectForKey:@"name"];
        _lat = [[response objectForKey:@"location"] objectForKey:@"lat"];
        _lng = [[response objectForKey:@"location"] objectForKey:@"lng"];
        _url_icon = @"";
    }
    return self;
}

@end
