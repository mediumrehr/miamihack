//
//  TRPRootViewController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPRootViewController.h"
#import "TRPRootView.h"
#import "TRPTripCreationViewController.h"
#import "TRPTripViewController.h"

@interface TRPRootViewController ()
<TRPRootViewDelegate, TRPTripCreationViewControllerDelegate>
@property (nonatomic, weak) id<TRPRootViewControllerAuthDelegate> authDelegate;
@end

@implementation TRPRootViewController

- (instancetype)initWithAuthDelegate:(id<TRPRootViewControllerAuthDelegate>)authDelegate;
{
    if (!(self = [super init])) {
        return nil;
    }
    _authDelegate = authDelegate;
    return self;
}

- (TRPRootView*)rootView
{
    return (TRPRootView*)self.view;
}

- (void)loadView
{
    self.view = [[TRPRootView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.rootView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    // check for list of trips, and start a new one if empty
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setCurrentViewController:(UIViewController *)currentViewController
{
    if ([self.currentViewController isEqual:currentViewController]) {
        return;
    }

    // set the new current view controller
    [self.currentViewController.view removeFromSuperview];
    _currentViewController = currentViewController;
    self.currentViewController.view.frame = self.rootView.contentView.bounds;
    [self.rootView.contentView addSubview:self.currentViewController.view];
}

- (void)createNewTrip
{
    TRPTripCreationViewController *creationViewController = [TRPTripCreationViewController new];
    creationViewController.delegate = self;
    self.currentViewController = creationViewController;
}

- (void)startTrip:(TRPTripModel *)model
{
    TRPTripViewController *tripViewController = [[TRPTripViewController alloc] init];
    self.currentViewController = tripViewController;
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

#pragma mark - TRPTripCreationViewController

- (void)controller:(TRPTripCreationViewController *)controller didCreateTrip:(TRPTripModel *)tripModel
{
    [self startTrip:tripModel];
}

#pragma mark - TRPRootViewDelegate

- (void)didTouchLogout:(TRPRootView *)rootView
{
    [_authDelegate logout];
}

@end
