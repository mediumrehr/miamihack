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
    
    IBOutlet UIButton *playButton;
}
- (IBAction)playButtonPressed:(id)sender;

@end
