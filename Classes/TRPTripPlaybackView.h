//
//  TRPTripPlaybackView.h
//  Tripster
//
//  Created by Rob Rehrig on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRPTripModel.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import <libechonest/ENAPI.h>
#import "TRPConstants.h"
#import "AudioControlsView.h"
#import <MediaPlayer/MediaPlayer.h>
@protocol TripPlaybackViewDelegate <NSObject>
-(void)pushCreationVC;

@end
@interface TRPTripPlaybackView : UIView <SPSessionDelegate, SPSessionPlaybackDelegate,ENAPIRequestDelegate,SPPlaybackManagerDelegate, AudioControlViewDelegate>
{
    TRPTripModel *tripModel;
    UILabel *_trackTitle;
    UILabel *_trackArtist;
    UILabel *_trackAlbum;
    UIImageView *_coverView;
    UISlider *_positionSlider;
    UISlider *_volumeSlider;
    
    SPPlaybackManager *_playbackManager;
    SPTrack *_currentTrack;
    NSMutableArray *trackUrlBuffer;
    int trackUrlBufferIndex;
    
    NSString *sessionID;
    NSString *requestType;
    
    BOOL canRequestTrack;
    BOOL *isPlaying;
    
}

- (IBAction)playButtonPressed:(id)sender;
- (IBAction)setTrackPosition:(id)sender;
- (IBAction)setVolume:(id)sender;
- (bool)getSongsForCurrentSession;
-(void) createSessionWithArtists:(NSArray*) artists;
-(void)getGenreRadioPlaylistWithGenres:(NSArray*)genre;

@property (nonatomic, strong) IBOutlet UILabel *trackTitle;
@property (nonatomic, strong) IBOutlet UILabel *trackArtist;
@property (nonatomic, strong) IBOutlet UILabel *trackAlbum;
@property (nonatomic, strong) IBOutlet UIImageView *coverView;
@property (nonatomic, strong) IBOutlet UISlider *positionSlider;
@property (nonatomic, strong) IBOutlet UISlider *volumeSlider;
@property (nonatomic, strong) IBOutlet AudioControlsView *audioControlView;
@property (nonatomic, strong) IBOutlet UIButton *thumbsUp;
@property (nonatomic, strong) IBOutlet UIButton *thumbsDown;

@property (nonatomic, strong) SPTrack *currentTrack;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;

@property id delegate;

@end
