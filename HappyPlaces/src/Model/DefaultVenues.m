//
//  DefaultVenues.m
//  HappyPlaces
//
//  Created by Rafael Assis on 4/10/15.
//  Copyright (c) 2015 rafaiOS. All rights reserved.
//

#import "DefaultVenues.h"
#import "FoursquareVenue.h"

@implementation DefaultVenues

- (id)initWithEntryType:(DefaultVenuesEntryType)entryType response:(id)response{
    self = [super init];
    if (self) {
        _entryType=entryType;
        switch (entryType) {
            case DefaultVenuesEntryTypeFourSquare:
            case DefaultVenuesEntryTypeFourSquareChurras:
                [self populateFourSquareModel:response];
                break;
        }
    }
    return self;
}

-(void)populateFourSquareModel:(id)response{
    FoursquareVenue * model = [[FoursquareVenue alloc] initWithResponse:response];
    _venueId = model.venueId;
    _venueTitle = model.venueTitle;
    _lat = model.lat;
    _lng = model.lng;
    _url_icon = model.url_icon;
}

@end
