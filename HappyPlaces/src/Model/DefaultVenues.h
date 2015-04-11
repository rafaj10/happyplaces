//
//  DefaultVenues.h
//  HappyPlaces
//
//  Created by Rafael Assis on 4/10/15.
//  Copyright (c) 2015 rafaiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiRequestManager.h"

@interface DefaultVenues : NSObject

@property DefaultVenuesEntryType entryType;
@property (nonatomic,strong) NSString * venueId;
@property (nonatomic,strong) NSString * venueTitle;
@property (nonatomic,strong) NSNumber * lat;
@property (nonatomic,strong) NSNumber * lng;
@property (nonatomic,strong) NSString * url_icon;

- (id)initWithEntryType:(DefaultVenuesEntryType)entryType response:(id)response;

@end
