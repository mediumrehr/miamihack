//
//  TRPTripModel.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRPTripModel : NSObject
{
    @protected
    NSString *_location;
    NSSet *_artistIDs;
    NSURL *_spotifyPlaylistURL;
    NSURL *_currentSpotifyTrackID;
}
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSSet *artistIDs;
@property (nonatomic, strong, readonly) NSURL *spotifyPlaylistURL;
@property (nonatomic, strong, readonly) NSURL *currentSpotifyTrackID;
@end


@interface TRPMutableTripModel : TRPTripModel
+ (TRPTripModel*) getTripModel;
- (void)setLocation:(NSString*)location;
- (void)setArtistIDs:(NSSet*)artistIDs;
- (void)setSpotifyPlaylistURL:(NSURL*)spotifyPlaylistURL;
- (void)setCurrentSpotifyTrackID:(NSURL*)currentSpotifyTrackID;

@end