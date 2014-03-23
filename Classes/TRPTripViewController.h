//
//  TRPTripViewController.h
//  
//
//  Created by Andrew Ayers on 3/22/14.
//
//

#import <UIKit/UIKit.h>
#import "TRPTripModel.h"
// #import "PlaylistModel.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface TRPTripViewController : UIViewController{
    SPTrack *_track;
    IBOutlet UIButton *playButton;
    SPPlaybackManager *plManager;
}
- (IBAction)playButtonPressed:(id)sender;

@end
