//
//  TRPPlaybackViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPPlaybackViewController.h"
#import "SPPlaylistPlaybackController.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "TRPTrackPlaybackTableViewCell.h"

@interface TRPPlaybackViewController ()
<SPPlaybackManagerDelegate, SPPlaylistDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIButton *nextTrackButton;
@property (nonatomic, strong) UIButton *prevTrackButton;
@property (nonatomic, strong) UIButton *togglePlaybackButton;
@property (nonatomic, strong) UITableView *trackListView;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;
@property (nonatomic, strong) SPPlaylistPlaybackController *playbackController;
@end

@implementation TRPPlaybackViewController

- (id)initWithPlaybackManager:(SPPlaybackManager *)playbackManager
           playbackController:(SPPlaylistPlaybackController*)playbackController
{
    NSParameterAssert(playbackController);
    NSParameterAssert(playbackManager);
    if (!(self = [super init])) {
        return nil;
    }

    _playbackManager = playbackManager;
    _playbackManager.delegate = self;
    
    _playbackController = playbackController;

    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.trackListView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.trackListView.delegate = self;
    self.trackListView.dataSource = self;
    [self.trackListView registerClass:[TRPTrackPlaybackTableViewCell class]
               forCellReuseIdentifier:@"TrackPlaybackCell"];
    [self.view addSubview:self.trackListView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters

- (void)setPlaylist:(SPPlaylist *)playlist
{
    if ([self.playlist isEqual:playlist]) {
        return;
    }

    _playbackController.playlist = playlist;
    _playbackController.playlist.delegate = self;

    if (!_playbackController.playlist) {
        [self.delegate didBecomeEmpty];
    }

    [self.trackListView reloadData];
}

#pragma mark - SPPlaylistDelegate

// BRUTE FORCE ALL THE THINGS

- (void)playlist:(SPPlaylist *)aPlaylist didAddItems:(NSArray *)items atIndexes:(NSIndexSet *)newIndexes
{
    [self.trackListView reloadData];
}

- (void)playlist:(SPPlaylist *)aPlaylist didRemoveItems:(NSArray *)items atIndexes:(NSIndexSet *)theseIndexesArentValidAnymore
{
    [self.trackListView reloadData];
}

- (void)playlist:(SPPlaylist *)aPlaylist didMoveItems:(NSArray *)items atIndexes:(NSIndexSet *)oldIndexes toIndexes:(NSIndexSet *)newIndexes
{
    [self.trackListView reloadData];
}

- (void)playlistDidChangeItems:(SPPlaylist *)aPlaylist
{
    [self.trackListView reloadData];
}

#pragma mark - Getters

- (SPPlaylist*)playlist
{
    return _playbackController.playlist;
}

- (SPTrack*)currentTrack
{
    return self.playbackManager.currentTrack;
}

- (void)updateCellSelection
{
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:self.playbackController.currentTrackIndex inSection:0];
    [self.trackListView selectRowAtIndexPath:selectedIndexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionTop];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark - SPPlaylistDelegate

#pragma mark - SPPlaybackManagerDelegate

- (void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager
{
    [self.delegate didStartPlaying];
    [_playbackController playbackManagerWillStartPlayingAudio:aPlaybackManager];
}

- (void)sessionDidEndPlayback
{
    [_playbackController sessionDidEndPlayback];
}

#pragma mark - UITableViewDataSource

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.f;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_playbackController.playlist.items count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRPTrackPlaybackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackPlaybackCell"];

    SPPlaylistItem *item = _playbackController.playlist.items[indexPath.row];
    SPTrack *track = (SPTrack*)item.item;
    cell.textLabel.text = track.name;
    cell.textLabel.textAlignment = NSTextAlignmentRight;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.playbackController.isPlaying
        || self.playbackController.currentTrackIndex != indexPath.row) {
        self.playbackController.currentTrackIndex = indexPath.row;
        self.playbackController.playing = YES;
    } else {
        self.playbackController.playing = NO;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.playbackController.playing = NO;
}

@end
