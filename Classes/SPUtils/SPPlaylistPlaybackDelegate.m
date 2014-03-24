//
//  SPPlaylistPlaybackDelegate.m
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "SPPlaylistPlaybackDelegate.h"

static const int ddLogLevel = LOG_LEVEL_DEBUG;

@implementation SPPlaybackManager (AutoPlaylistPlayback)

- (SPPlaylistPlaybackDelegate*)playlistPlaybackDelegate
{
    return [self.delegate isKindOfClass:[SPPlaylistPlaybackDelegate class]] ?
        (SPPlaylistPlaybackDelegate*)self.delegate : nil;
}

@end


@interface SPPlaylistPlaybackDelegate ()
<SPPlaybackManagerDelegate>

@end

@implementation SPPlaylistPlaybackDelegate

- (id)initWithPlaylist:(SPPlaylist*)playlist playbackManager:(SPPlaybackManager *)manager
{
    if (!(self = [super init])) {
        return nil;
    }
    _playlist = playlist;
    _playbackManager = manager;
    _playbackManager.delegate = self;

    return self;
}

- (void)setPlaylist:(SPPlaylist *)playlist
{
    if ([_playlist isEqual:playlist]) {
        return;
    }

    _playlist = playlist;
    _currentTrackIndex = 0;
    [self playTrackAtIndex:0];
}

- (void)setCurrentTrackIndex:(int)currentTrackIndex
{
    if (_currentTrackIndex == currentTrackIndex) {
        return;
    }

    _currentTrackIndex = currentTrackIndex;
    [self playTrackAtIndex:_currentTrackIndex];
}

- (void)playTrackAtIndex:(int)index
{
    if (!_playlist) {
        return;
    }

    SPPlaylistItem *item = _playlist.items[index];
    DDLogInfo(@"Playing track: %@ from playlist: %@", item.itemURL, _playlist.spotifyURL);
    [_playbackManager playTrack:item.item callback:^ (NSError* error) {
        if (error) {
            DDLogError(@"Failed to play track: %@", item);
        }
    }];
}

#pragma mark - PlaybackManagerDelegate

- (void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager
{

}

- (void)sessionDidEndPlayback
{
    if (_currentTrackIndex < [_playlist.items count] - 1) {
        _currentTrackIndex += 1;
        [self playTrackAtIndex:_currentTrackIndex];
    }
}

@end
