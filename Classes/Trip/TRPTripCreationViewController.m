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

    return self;
}

- (TRPTripCreationView*)creationView
{
    return (TRPTripCreationView*)self.view;
}

- (void)loadView
{
    [super loadView];
    // Do any additional setup after loading the view.
    self.view = [[TRPTripCreationView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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

@end
