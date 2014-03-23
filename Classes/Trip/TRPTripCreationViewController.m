//
//  TRPTripCreationViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripCreationViewController.h"
#import "TRPTripCreationView.h"
#import "TRPTripLocationStep.h"
#import "TRPTripArtistSelectionStep.h"
#import "TRPTripViewController.h"
#import "ENAPI+RAC.h"

@interface TRPTripCreationViewController ()
<TripCreationViewDelegate>
@property (nonatomic, strong) TRPTripLocationStep *tripLocationStep;
@property (nonatomic, strong) TRPTripArtistSelectionStep *tripArtistSelectionStep;
@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) RACDisposable *currentArtistRequest;
@end


@implementation TRPTripCreationViewController

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    _tripLocationStep = [TRPTripLocationStep new];
    _tripArtistSelectionStep = [TRPTripArtistSelectionStep new];

    return self;
}

- (TRPTripCreationView*)creationView
{
    return (TRPTripCreationView*)self.view;
}

- (void)loadView
{
    TRPTripCreationView* creationView = [[TRPTripCreationView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    creationView.delegate = self;
    self.view = creationView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RACSignal*)createTrip
{
    TRPMutableTripModel *model = TRPTripModelFromSteps([@[_tripArtistSelectionStep,
                                                          _tripLocationStep] rac_sequence]);
    RACSignal *creationSignal = [[RACSignal alloc] init];
    return creationSignal;
}

#pragma mark - TRPTripCreationViewDelegate

- (void)creationView:(TRPTripCreationView *)view didUpdateLocation:(NSString *)location
{
    if ([_tripLocationStep.location isEqualToString:location]) {
        return;
    }
    _tripLocationStep.location = location;
    [_tripArtistSelectionStep removeAllArtists];

    __weak __typeof(self) weakSelf = self;
    [_currentArtistRequest dispose];
    _currentArtistRequest = [[ENAPI requestArtistsForLocation:location]
     subscribeNext:^(id artistResponse) {
         [weakSelf.creationView setPossibleArtists:artistResponse[@"response"][@"artists"]
                                            genres:nil];
     }
     error:^(NSError *error) {
         NSString *errorMessage = [NSString stringWithFormat:
                                   @"Failed to find artists for %@. %@", location, error];
         [[[UIAlertView alloc] initWithTitle:@"Artist Search Failed"
                                     message:errorMessage
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] show];
     }];
}

- (void)creationView:(TRPTripCreationView *)view didAddArtist:(id)artist
{
    [_tripArtistSelectionStep addArtist:artist];
}

- (void)creationView:(TRPTripCreationView *)view didRemoveArtist:(id)artist
{
    [_tripArtistSelectionStep removeArtist:artist];
}

- (BOOL)isArtistSelected:(NSString *)artistID
{
    return [[_tripArtistSelectionStep.artists objectsPassingTest:^BOOL(NSDictionary *artist, BOOL *stop) {
        if ([artist[@"id"] isEqualToString:artistID]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }] count] != 0;
}

- (BOOL)isGenreSelected:(NSString *)genreID
{
    return NO;
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
    
//    [_playbackView setDelegate:self];
//    if([_tripmodel needsNewPlaylist]){
//        if ([_tripmodel isGenre]) {
//            [_playbackView getGenreRadioPlaylistWithGenres:[_tripmodel chosenSeeds]];
//        }else{
//            [_playbackView createSessionWithArtists:[_tripmodel chosenSeeds]];
//            BOOL didSucceedNewTracks = [_playbackView getSongsForCurrentSession];
//            if(!didSucceedNewTracks){
//                NSLog(@"No new tracks recieved");
//                // Error handling?
//            }
//    }
//    }
//    self.view = _playbackView;
}
-(void)pushCreationVC{
//    [_creationView setDelegate:self];
//    self.view = _creationView;
}

@end
