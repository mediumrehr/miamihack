//
//  TRPTripStorage.h
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRPTripModel.h"

@protocol TripStorage <NSObject>

- (instancetype)initWithUserID:(NSString*)userID;

- (NSArray*)allTrips;

- (TRPTripModel*)lastTrip;
- (void)setLastTrip:(TRPTripModel*)model;

- (TRPTripModel*)tripWithIdentifier:(NSString*)tripID;

- (void)saveTrips:(id<NSFastEnumeration>)trips;
- (void)saveTrip:(TRPTripModel*)model;

- (void)deleteTrips:(id<NSFastEnumeration>)trips;
- (void)deleteTrip:(NSString*)tripID;

- (void)synchronize;

@end

@interface SimpleTripStorage : NSObject
<TripStorage>

@end
