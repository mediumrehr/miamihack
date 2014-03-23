//
//  TRPTripCreationViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripCreationViewController.h"
#import "TRPTripLocationStep.h"
#import "TRPTripArtistSelectionStep.h"
#import "TRPTripViewController.h"

@interface TRPTripCreationViewController ()
@property (nonatomic, strong) TRPTripLocationStep *tripLocationStep;
@property (nonatomic, strong) TRPTripArtistSelectionStep *tripArtistSelectionStep;
@end


@implementation TRPTripCreationViewController
- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    _tripLocationStep = [TRPTripLocationStep new];
    _tripArtistSelectionStep = [TRPTripArtistSelectionStep new];
    _creationView = [[TRPTripCreationView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _playbackView = [[TRPTripPlaybackView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    return self;
}

- (TRPTripCreationView*)creationView
{
    return (TRPTripCreationView*)self.view;
}

- (void)loadView
{
    [super loadView];
    _tripmodel = [TRPMutableTripModel getTripModel];
    // Do any additional setup after loading the view.
    [_creationView setDelegate:self];
    self.view = _creationView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createStep
{
    TRPTripModel *model = TRPTripModelFromSteps([@[_tripArtistSelectionStep, _tripLocationStep] rac_sequence]);
    NSLog(@"Created a trip! %@", model);
}

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
-(void)pushPlaybackVC{
    //[self presentViewController:[[TRPTripViewController alloc] init] animated:YES completion:nil];
    
    [_playbackView setDelegate:self];
    if([_tripmodel needsNewPlaylist]){
        if ([_tripmodel isGenre]) {
            [_playbackView getGenreRadioPlaylistWithGenres:[_tripmodel chosenSeeds]];
        }else{
            [_playbackView createSessionWithArtists:[_tripmodel chosenSeeds]];
            BOOL didSucceedNewTracks = [_playbackView getSongsForCurrentSession];
            if(!didSucceedNewTracks){
                NSLog(@"No new tracks recieved");
                // Error handling?
            }
    }
    }
    [_playbackView setDelegate:self];
    [UIView transitionFromView:self.view toView:_playbackView duration:0.25 options:UIViewAnimationOptionTransitionFlipFromRight completion:^ (BOOL finished) {
        if (!finished) {
            return;
        }
        self.view = _playbackView;
    }];
}
-(void)pushCreationVC{
    [_creationView setDelegate:self];
    [UIView transitionFromView:self.view toView:_creationView duration:0.25 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^ (BOOL finished) {
        if (!finished) {
            return;
        }
        self.view = _creationView;
    }];
}

@end
