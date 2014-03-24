//
//  TRPTripStorage.m
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripStorage.h"

/// NSUserDefaults Storage Keys

#define kSimpleTripStorageDomainName @"com.tripster.tripstorage.simple"

@interface SimpleTripStorage ()
@property (nonatomic, strong) NSMutableDictionary *storage;
@property (nonatomic, strong) NSString *userID;
@end

@implementation SimpleTripStorage

- (id)initWithUserID:(NSString *)userID
{
    NSParameterAssert(userID);
    if (!(self = [super init])) {
        return nil;
    }

    _userID = userID;

    return self;
}

- (NSUInteger)hash
{
    return [_userID hash];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    } else if ([object isKindOfClass:[SimpleTripStorage class]]) {
        return [self isEqualToSimpleStorage:object];
    }
    return NO;
}

- (BOOL)isEqualToSimpleStorage:(SimpleTripStorage*)simpleStorage
{
    return [_userID isEqualToString:simpleStorage.userID];
}

- (void)dealloc
{
    [self synchronize];
}

- (NSString*)storageDomainName
{
    return [NSString stringWithFormat:@"%@.%@", kSimpleTripStorageDomainName, _userID];
}

- (NSMutableDictionary*)storage
{
    if (_storage) {
        return _storage;
    }
    _storage = [[[NSUserDefaults standardUserDefaults]
                 persistentDomainForName:[self storageDomainName]] mutableCopy];
    if (!_storage) {
        _storage = [NSMutableDictionary new];
    }

    // deserialize trip data
    if (_storage[@"trips"]) {
        _storage[@"trips"] = [[[_storage[@"trips"] allValues] rac_sequence]
                              foldLeftWithStart:[[NSMutableDictionary alloc] initWithCapacity:[_storage[@"trips"] count]]
                              reduce:^id(NSMutableDictionary *deserializedTrips, RACTuple *keyValuePair) {
                                  RACTupleUnpack(NSString *tripID, NSData *tripData) = keyValuePair;
                                  NSAssert([tripData isKindOfClass:[NSData class]],
                                           @"This should be the first time this trip ID was accessed");
                                  TRPTripModel *tripModel = [NSKeyedUnarchiver unarchiveObjectWithData:tripData];
                                  NSAssert(tripModel,
                                           @"Failed to unarchive trip model with ID %@ from data: %@",
                                           tripID, tripData);
                                  deserializedTrips[tripID] = tripModel;
                                  return deserializedTrips;
                              }];
    } else {
        _storage[@"trips"] = [NSMutableDictionary new];
    }

    if (_storage[@"lastTrip"]) {
        _storage[@"lastTrip"] = [NSKeyedUnarchiver unarchiveObjectWithData:_storage[@"lastTrip"]];
    }

    return _storage;
}

- (NSArray*)allTrips
{
    return [[self.storage[@"trips"] allValues] sortedArrayUsingSelector:@selector(dateCreated)];
}

- (void)setLastTrip:(TRPTripModel*)model
{
    self.storage[@"lastTrip"] = model;
}

- (NSString*)lastTrip
{
    return self.storage[@"lastTrip"];
}

- (NSString*)tripWithIdentifier:(NSString*)tripID
{
    return self.storage[@"trips"][tripID];
}

- (void)saveTrips:(id<NSFastEnumeration>)trips
{
    for (TRPTripModel *trip in trips) {
        [self saveTrip:trip];
    }
}

- (void)saveTrip:(TRPTripModel*)model
{
    self.storage[@"trips"][model.tripID] = model;
}

- (void)deleteTrips:(id<NSFastEnumeration>)trips
{
    for (TRPTripModel *trip in trips) {
        [self deleteTrip:trip.tripID];
    }
}

- (void)deleteTrip:(NSString*)tripID
{
    [self.storage[@"trips"] removeObjectForKey:tripID];
    if ([self.lastTrip isEqual:tripID]) {
        [self setLastTrip:nil];
    }
}

- (void)synchronize
{
    NSDictionary *serializedDictionary = nil;
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:serializedDictionary
                                                       forName:[self storageDomainName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
