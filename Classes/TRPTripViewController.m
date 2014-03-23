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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    SPSession *aSession = [SPSession sharedSession];
    SPPlaybackManager *plManager = [[SPPlaybackManager alloc] initWithPlaybackSession:aSession];
    [SPTrack trackForTrackURL:[NSURL URLWithString:@"spotify:track:6q0f0zpByDs4Zk0heXZ3cO"] inSession:[SPSession sharedSession] callback:^(SPTrack *track) {
        if (track != nil) {
            [plManager playTrack:track callback:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonPressed:(id)sender {
}
@end
