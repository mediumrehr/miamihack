//
//  TRPTripViewController.h
//  
//
//  Created by Andrew Ayers on 3/22/14.
//
//


//Deprecated

#import <UIKit/UIKit.h>
#import "TRPTripModel.h"
//#import "TRPPlaylistModel.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import <libechonest/ENAPI.h>
#import "TRPConstants.h"
#import "AudioControlsView.h"

@interface TRPTripViewController : UIViewController<SPSessionDelegate, SPSessionPlaybackDelegate,ENAPIRequestDelegate,SPPlaybackManagerDelegate,AudioControlViewDelegate>{
    IBOutlet UIButton *playButton;
    //TRPPlaylistModel *plModel;
    TRPTripModel *tripModel;
    UILabel *_trackTitle;
	UILabel *_trackArtist;
	UIImageView *_coverView;
	UISlider *_positionSlider;
	SPPlaybackManager *_playbackManager;
	SPTrack *_currentTrack;
    NSMutableArray *trackUrlBuffer;
    int trackUrlBufferIndex;
    NSString *sessionID;
    BOOL canRequestTrack;
    NSString *requestType;
    BOOL *isPlaying;
    IBOutlet AudioControlsView *audioControlView;
}
- (IBAction)playButtonPressed:(id)sender;
- (IBAction)setTrackPosition:(id)sender;
- (IBAction)setVolume:(id)sender;

@property (nonatomic, strong) IBOutlet UILabel *trackTitle;
@property (nonatomic, strong) IBOutlet UILabel *trackArtist;
@property (nonatomic, strong) IBOutlet UIImageView *coverView;
@property (nonatomic, strong) IBOutlet UISlider *positionSlider;

@property (nonatomic, strong) SPTrack *currentTrack;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;
@end




