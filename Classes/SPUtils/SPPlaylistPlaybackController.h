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

@protocol SPPlaybackController <NSObject>

@property (nonatomic, assign) NSUInteger currentTrackIndex;
@property (nonatomic, assign, getter = isPlaying) BOOL playing;

- (id)currentPlaylistableItem;

- (void)playFirstTrackFrom:(id<SPPlaylistableItem>)context;

- (void)playTrack:(SPTrack*)track from:(id<SPPlaylistableItem>)context;

- (void)playNextTrack;

- (void)playPreviousTrack;

- (BOOL)togglePlayback;

@end

@interface SPPlaylistPlaybackController : NSObject
<SPPlaybackManagerDelegate, SPPlaybackController>
@property (nonatomic, strong) SPPlaylist *playlist;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;

@end
