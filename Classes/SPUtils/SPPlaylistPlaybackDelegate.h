//
//  SPPlaylistPlaybackDelegate.h
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import <CocoaLibSpotify/SPPlaybackManager.h>
#import <CocoaLibSpotify/SPPlaylist.h>

@class SPPlaylistPlaybackDelegate;
@interface SPPlaybackManager (AutoPlaylistPlayback)

- (SPPlaylistPlaybackDelegate*)playlistPlaybackDelegate;

@end


@interface SPPlaylistPlaybackDelegate : NSObject
@property (nonatomic, strong) SPPlaylist *playlist;
@property (nonatomic, weak) SPPlaybackManager *playbackManager;
@property (nonatomic, assign) int currentTrackIndex;

- (id)initWithPlaylist:(SPPlaylist*)playlist playbackManager:(SPPlaybackManager*)manager;

@end
