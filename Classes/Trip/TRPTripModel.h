//
//  TRPTripModel.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRPTripModel : NSObject
<NSCopying, NSCoding, NSMutableCopying>
{
    @protected
    NSString *_tripID;
    NSDate *_dateCreated;
    NSString *_location;
    NSSet *_artistIDs;
    NSSet *_genreIDs;
    NSURL *_spotifyPlaylistURL;
    NSURL *_currentSpotifyTrackID;
}
@property (nonatomic, strong, readonly) NSString *tripID;
@property (nonatomic, strong, readonly) NSDate *dateCreated;
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSSet *artistIDs;
@property (nonatomic, strong, readonly) NSSet *genreIDs;
@property (nonatomic, strong, readonly) NSURL *spotifyPlaylistURL;
@property (nonatomic, strong, readonly) NSURL *currentSpotifyTrackID;
@end


@interface TRPMutableTripModel : TRPTripModel

- (void)setTripID:(NSString*)tripID;
- (void)setDateCreated:(NSDate*)dateCreated;
- (void)setLocation:(NSString*)location;
- (void)setArtistIDs:(NSSet*)artistIDs;
- (void)setGenreIDs:(NSSet*)genreIDs;
- (void)setSpotifyPlaylistURL:(NSURL*)spotifyPlaylistURL;
- (void)setCurrentSpotifyTrackID:(NSURL*)currentSpotifyTrackID;

@end