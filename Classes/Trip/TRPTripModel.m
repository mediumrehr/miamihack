//
//  TRPTripModel.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripModel.h"
static TRPTripModel *tripModelCache;
@interface TRPTripModel ()
@end

@implementation TRPTripModel

#warning implement NSCopying and override hash/isEqual:

@end

@interface TRPMutableTripModel ()
@end

@implementation TRPMutableTripModel
@synthesize chosenSeeds;
+(TRPTripModel *) getTripModel
{
    if (!tripModelCache)
        tripModelCache = [[super alloc] init];
    return tripModelCache;
    
}


- (void)setLocation:(NSString*)location
{
    _location = location;
}

- (void)setArtistIDs:(NSMutableArray*)artistIDs
{
    _artistIDs = artistIDs;
}

- (void)setSpotifyPlaylistURL:(NSURL*)spotifyPlaylistURL
{
    _spotifyPlaylistURL = spotifyPlaylistURL;
}

- (void)setCurrentSpotifyTrackID:(NSURL*)currentSpotifyTrackID
{
    _currentSpotifyTrackID = currentSpotifyTrackID;
}

@end
