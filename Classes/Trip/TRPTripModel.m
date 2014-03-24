//
//  TRPTripModel.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripModel.h"

@interface TRPTripModel ()
@end

@implementation TRPTripModel

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    _tripID = [[NSUUID UUID] UUIDString];
    _dateCreated = [NSDate date];
    _artistIDs = [NSSet new];
    _genreIDs = [NSSet new];


    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSKeyedUnarchiver *)aDecoder
{
    if (!(self = [self init])) {
        return nil;
    }

    _location = [aDecoder decodeObjectForKey:@"location"];
    _tripID = [aDecoder decodeObjectForKey:@"tripID"];
    _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
    _artistIDs = [NSSet setWithArray:[aDecoder decodeObjectForKey:@"artistIDs"]];
    _genreIDs = [NSSet setWithArray:[aDecoder decodeObjectForKey:@"genreIDs"]];
    _spotifyPlaylistURL = [aDecoder decodeObjectForKey:@"spotifyPlaylistURL"];
    _currentSpotifyTrackID = [aDecoder decodeObjectForKey:@"currentSpotifyTrackID"];

    return self;
}

- (void)encodeWithCoder:(NSKeyedArchiver *)aCoder
{
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:_tripID forKey:@"tripID"];
    [aCoder encodeObject:[_artistIDs allObjects] forKey:@"artistIDs"];
    [aCoder encodeObject:[_genreIDs allObjects] forKey:@"genreIDs"];
    [aCoder encodeObject:_spotifyPlaylistURL forKey:@"spotifyPlaylistTrackURL"];
    [aCoder encodeObject:_currentSpotifyTrackID forKey:@"currentSpotifyTrackID"];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    TRPTripModel *copy = [[TRPTripModel allocWithZone:zone] init];
    [self setPropertiesOfCopy:copy];
    return copy;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    TRPMutableTripModel *mutableCopy = [[TRPMutableTripModel allocWithZone:zone] init];
    [self setPropertiesOfCopy:mutableCopy];
    return mutableCopy;
}

- (void)setPropertiesOfCopy:(TRPTripModel*)copy
{
    copy->_tripID = _tripID;
    copy->_dateCreated = _dateCreated;
    copy->_location = _location;
    copy->_artistIDs = _artistIDs;
    copy->_genreIDs = _genreIDs;
    copy->_spotifyPlaylistURL = _spotifyPlaylistURL;
    copy->_currentSpotifyTrackID = _currentSpotifyTrackID;
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return [_tripID hash];
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    } else if ([object isKindOfClass:[TRPTripModel class]]) {
        return [self isEqualToTripModel:object];
    }
    return NO;
}

- (BOOL)isEqualToTripModel:(TRPTripModel*)model
{
    NSParameterAssert([model isKindOfClass:[TRPTripModel class]]);
    return [model.tripID isEqualToString:self.tripID];
}

- (BOOL)diff:(TRPTripModel*)model
{
    return !((model.tripID == _tripID || [model.tripID isEqual:_tripID])
             && (model.location == _location || [model.location isEqual:_location])
             && (model.artistIDs == _artistIDs || [model.artistIDs isEqual:_artistIDs])
             && (model.genreIDs == _genreIDs || [model.genreIDs isEqual:_genreIDs])
             && (model.spotifyPlaylistURL == _spotifyPlaylistURL || [model.spotifyPlaylistURL isEqual:_spotifyPlaylistURL])
             && (model.currentSpotifyTrackID == _currentSpotifyTrackID || [model.currentSpotifyTrackID isEqual:_currentSpotifyTrackID]));
}

@end

@interface TRPMutableTripModel ()
@end

@implementation TRPMutableTripModel

- (void)setDateCreated:(NSDate *)dateCreated
{
    [self willChangeValueForKey:@"dateCreated"];
    _dateCreated = dateCreated;
    [self didChangeValueForKey:@"dateCreated"];
}

- (void)setTripID:(NSString *)tripID
{
    [self willChangeValueForKey:@"tripID"];
    _tripID = tripID;
    [self didChangeValueForKey:@"tripID"];
}

- (void)setLocation:(NSString*)location
{
    [self willChangeValueForKey:@"location"];
    _location = location;
    [self didChangeValueForKey:@"location"];
}

- (void)setArtistIDs:(NSSet*)artistIDs
{
    [self willChangeValueForKey:@"artistIDs"];
    _artistIDs = artistIDs;
    [self didChangeValueForKey:@"artistIDs"];
}

- (void)setGenreIDs:(NSSet *)genreIDs
{
    [self willChangeValueForKey:@"genreIDs"];
    _genreIDs = genreIDs;
    [self didChangeValueForKey:@"genreIDs"];
}

- (void)setSpotifyPlaylistURL:(NSURL*)spotifyPlaylistURL
{
    [self willChangeValueForKey:@"spotifyPlaylistURL"];
    _spotifyPlaylistURL = spotifyPlaylistURL;
    [self didChangeValueForKey:@"spotifyPlaylistURL"];
}

- (void)setCurrentSpotifyTrackID:(NSURL*)currentSpotifyTrackID
{
    [self willChangeValueForKey:@"currentSpotifyTrackID"];
    _currentSpotifyTrackID = currentSpotifyTrackID;
    [self didChangeValueForKey:@"currentSpotifyTrackID"];
}

@end
