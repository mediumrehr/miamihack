//
//  TRPPlaybackViewController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPPlaylistPlaybackController.h"

@class TRPPlaybackViewController;
@protocol TRPPlaybackViewControllerDelegate <NSObject>

- (void)didStartPlaying;
- (void)didBecomeEmpty;

@end

@class SPPlaybackManager;
@class SPPlaylist;
@class SPTrack;
@interface TRPPlaybackViewController : UIViewController

@property (nonatomic, weak) id<TRPPlaybackViewControllerDelegate> delegate;

@property (nonatomic, strong, readonly) SPTrack *currentTrack;

// TODO: generalize to "playlistable" to play back individual tracks, albums, etc.
@property (nonatomic, strong) SPPlaylist *playlist;

- (id)initWithPlaybackManager:(SPPlaybackManager*)playbackManager
           playbackController:(SPPlaylistPlaybackController*)playbackController;

@end
