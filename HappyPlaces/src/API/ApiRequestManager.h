//
//  ApiRequestManager.h
//  conviva
//
//  Created by Rafael Assis on 3/24/15.
//  Copyright (c) 2015 caiena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef enum {
    DefaultVenuesEntryTypeFourSquare,
    DefaultVenuesEntryTypeGooglePlace,
    DefaultVenuesEntryTypeFourSquareChurras
} DefaultVenuesEntryType;

@interface ApiRequestManager : NSObject

+ (ApiRequestManager *)sharedApi;

- (void)searchWithVenueType:(DefaultVenuesEntryType)entryType
            currentLocation:(NSDictionary *)locations
             newMidiasBlock:(void (^)(NSArray *venues))newVenues;

@end
