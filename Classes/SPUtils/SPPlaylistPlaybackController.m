//
//  SPPlaylistPlaybackDelegate.m
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "SPPlaylistPlaybackController.h"
#import <CocoaLibSpotify/SPCommon.h>
static const int ddLogLevel = LOG_LEVEL_DEBUG;


@interface SPPlaylistPlaybackController ()
{
    NSUInteger _currentTrackIndex;
}
@end

@implementation SPPlaylistPlaybackController

- (void)setPlaylist:(SPPlaylist *)playlist
{
    if ([_playlist isEqual:playlist]) {
        return;
    }

    _playlist = playlist;
    _currentTrackIndex = NSNotFound;
    [self playTrackAtIndex:0];
}

#pragma mark - Public API

- (id)currentPlaylistableItem
{
    return _playlist;
}

- (void)playTrack:(SPTrack*)track from:(id<SPPlaylistableItem>)context
{
    SPPlaylist *playlist = (SPPlaylist*)context;
    NSUInteger trackIndex = [_playlist.items indexOfObjectPassingTest:^BOOL(SPPlaylistItem *item,
                                                                            NSUInteger idx,
                                                                            BOOL *stop) {
        return [item.itemURL isEqual:track.spotifyURL];
    }];
    if (trackIndex != NSNotFound) {
        [self playTrackAtIndex:trackIndex from:playlist];
    }
}

- (void)playTrackAtIndex:(NSUInteger)trackIndex from:(id<SPPlaylistableItem>)context
{
    NSParameterAssert(trackIndex != NSNotFound);
    BOOL isNewPlaylist = [_playlist isEqual:context];
    _playlist = (SPPlaylist*)context;
    if (isNewPlaylist
        && _currentTrackIndex != NSNotFound
        && _currentTrackIndex != trackIndex) {
        [self playTrackAtIndex:trackIndex];
    }
}

- (void)playFirstTrackFrom:(id<SPPlaylistableItem>)context
{
    [self setPlaylist:(SPPlaylist*)context];
}

- (void)playNextTrack
{
    if (_currentTrackIndex < [_playlist.items count] - 1) {
        _currentTrackIndex += 1;
        [self playTrackAtIndex:_currentTrackIndex];
    }
}

- (void)playPreviousTrack
{
    if (_currentTrackIndex > 0) {
        _currentTrackIndex -= 1;
        [self playTrackAtIndex:_currentTrackIndex];
    }
}

- (BOOL)togglePlayback
{
    return self.playbackManager.isPlaying = !self.playbackManager.isPlaying;
}

- (BOOL)isPlaying
{
    return self.playbackManager.isPlaying;
}

- (BOOL)playing
{
    return [self isPlaying];
}

- (void)setPlaying:(BOOL)playing
{
    self.playbackManager.isPlaying = playing;
}

- (NSUInteger)currentTrackIndex
{
    return _currentTrackIndex;
}

- (void)setCurrentTrackIndex:(NSUInteger)currentTrackIndex
{
    if (_currentTrackIndex == currentTrackIndex) {
        return;
    }

    _currentTrackIndex = currentTrackIndex;
    [self playTrackAtIndex:_currentTrackIndex];
}

- (void)playTrackAtIndex:(NSUInteger)index
{
    if (!_playlist) {
        return;
    }

    SPPlaylistItem *item = _playlist.items[index];
    DDLogInfo(@"Attempting track playback: %@ from playlist: %@", item.itemURL, _playlist.spotifyURL);
    NSParameterAssert(_playbackManager);
    if (!item.item) {
        return;
    }
    [_playbackManager playTrack:item.item callback:^ (NSError* error) {
        if (error) {
            DDLogError(@"Failed to play track: %@", item);
        } else {
            DDLogInfo(@"track playback succeeded! %@ from playlist: %@", item.itemURL, _playlist.spotifyURL);
            // TODO: preload the next one?
        }
    }];
}

#pragma mark - PlaybackManagerDelegate

- (void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager
{

}

- (void)sessionDidEndPlayback
{
    [self playNextTrack];
}

@end
