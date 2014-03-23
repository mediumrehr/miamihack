//
//  TRPTripViewController.m
//  
//
//  Created by Andrew Ayers on 3/22/14.
//
//

#import "TRPTripViewController.h"


@interface TRPTripViewController ()

@end

@implementation TRPTripViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        plManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonPressed:(id)sender {
    [[SPSession sharedSession] trackForURL:[NSURL URLWithString:@"spotify-US:artist:7qG3b048QCHVRO5Pv1T5lw"] callback:^(SPTrack *track) {
     if (track != nil) {
        [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
            [plManager playTrack:track callback:^(NSError *error) {
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
                                                                             message:[error localizedDescription]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                             [alert show];
                         } else {
                             _track = track;
                         }
                         
                     }];
                 }];
             }
         }];
}
@end
