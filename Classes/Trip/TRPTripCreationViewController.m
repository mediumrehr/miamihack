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
    TRPTC = [[TRPTripCreationView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TRPTP = [[TRPTripPlaybackView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    return self;
}

- (TRPTripCreationView*)creationView
{
    return (TRPTripCreationView*)self.view;
}

- (void)loadView
{
    [super loadView];
    tripmodel = [TRPMutableTripModel getTripModel];
    // Do any additional setup after loading the view.
    [TRPTC setDelegate:self];
    self.view = TRPTC;
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
    
    [TRPTP setDelegate:self];
    if([tripmodel needsNewPlaylist]){
        if ([tripmodel isGenre]) {
            [TRPTP getGenreRadioPlaylistWithGenres:[tripmodel chosenSeeds]];
        }else{
            [TRPTP createSessionWithArtists:[tripmodel chosenSeeds]];
            BOOL didSucceedNewTracks = [TRPTP getSongsForCurrentSession];
            if(!didSucceedNewTracks){
                NSLog(@"No new tracks recieved");
                // Error handling?
            }
    }
    }
    self.view = TRPTP;
}
-(void)pushCreationVC{
    [TRPTC setDelegate:self];
    self.view = TRPTC;
}

@end
