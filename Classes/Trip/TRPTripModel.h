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
    NSMutableArray *_artistIDs;
    NSMutableArray *_genreIDs;
    NSURL *_spotifyPlaylistURL;
    NSURL *_currentSpotifyTrackID;
}
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSMutableArray *artistIDs;
@property (nonatomic, strong, readonly) NSMutableArray *genreIDs;
@property (nonatomic, strong, readonly) NSURL *spotifyPlaylistURL;
@property (nonatomic, strong, readonly) NSURL *currentSpotifyTrackID;
@property (nonatomic, strong) NSMutableArray *chosenSeeds;
@property BOOL isGenre;
@property BOOL needsNewPlaylist;
@end


@interface TRPMutableTripModel : TRPTripModel
+ (TRPTripModel*) getTripModel;
- (void)setLocation:(NSString*)location;
- (void)setArtistIDs:(NSMutableArray*)artistIDs;
- (void)setGenreIDs:(NSMutableArray*)genreIDs;
- (void)setSpotifyPlaylistURL:(NSURL*)spotifyPlaylistURL;
- (void)setCurrentSpotifyTrackID:(NSURL*)currentSpotifyTrackID;

@end