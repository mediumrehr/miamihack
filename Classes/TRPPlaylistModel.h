//
//  TRPPlaylistModel.h
//  Tripster
//
//  Created by Marko Gill on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libechonest/ENAPI.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "TRPConstants.h"
@protocol PlaylistModelDelegate <NSObject>

@optional
-(void) successfullyCreatedPlaylist;
-(void)failedToCreatePlaylist;
-(void)didReceiveNextSong:(NSString *)urlString;

@end
@interface TRPPlaylistModel : NSObject <ENAPIRequestDelegate>
{}

- (void) createSessionWithArtists:(NSArray*) artists;
- (bool) getSongsForCurrentSession;
@property (nonatomic) NSString *sessionID;
@property (nonatomic) NSString *requestType;
@property (nonatomic) bool canRequestTrack;
@property id delegate;

@end
