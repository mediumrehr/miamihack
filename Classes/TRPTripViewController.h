//
//  TRPTripViewController.h
//  
//
//  Created by Andrew Ayers on 3/22/14.
//
//

#import <UIKit/UIKit.h>
#import "TRPTripModel.h"
#import "TRPPlaylistModel.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface TRPTripViewController : UIViewController<SPSessionDelegate, SPSessionPlaybackDelegate>{
    IBOutlet UIButton *playButton;
    TRPPlaylistModel *plModel;
    UILabel *_trackTitle;
	UILabel *_trackArtist;
	UIImageView *_coverView;
	UISlider *_positionSlider;
	SPPlaybackManager *_playbackManager;
	SPTrack *_currentTrack;
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




