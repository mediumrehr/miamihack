//
//  TRPAppDelegate.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPAppDelegate.h"
#import <CocoaLibSpotify.h>
#import <SPPlaybackManager.h>
#import <libechonest/ENAPI.h>
#import <MSDynamicsDrawerViewController/MSDynamicsDrawerViewController.h>

#import "TRPConstants.h"
#import "TRPAuthController.h"
#import "TRPLeftDrawerViewController.h"
#import "TRPTripListViewController.h"
#import "TRPTripStorage.h"

@interface TRPAppDelegate ()
<UIApplicationDelegate, TRPAuthControllerDelegate, TRPLeftDrawerViewControllerDelegate,  MSDynamicsDrawerViewControllerDelegate>
@property (strong, nonatomic) MSDynamicsDrawerViewController *rootViewController;
@property (strong, nonatomic) TRPLeftDrawerViewController *leftDrawerViewController;
@property (strong, nonatomic) SPPlaybackManager *playbackManager;
@property (strong, nonatomic) TRPAuthController *authController;
@end

@implementation TRPAppDelegate

+ (void)configureSharedSpotifySession
{
	NSString *userAgent = [[[NSBundle mainBundle] infoDictionary] valueForKey:(__bridge NSString *)kCFBundleIdentifierKey];
	NSData *appKey = [NSData dataWithBytes:&SPOTIFY_APP_KEY length:SPOTIFY_APP_KEY_SIZE];

	NSError *error = nil;
	[SPSession initializeSharedSessionWithApplicationKey:appKey
											   userAgent:userAgent
										   loadingPolicy:SPAsyncLoadingManual
												   error:&error];
	if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}
}

+ (void)configureEchoNestAPI
{
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
}

#pragma mark - Login

- (void)showLoginViewController
{
    SPLoginViewController *loginViewController = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
    loginViewController.allowsCancel = NO;
    loginViewController.dismissesAfterLogin = YES;
    loginViewController.navigationBarHidden = YES;
    // ^ To allow the user to cancel (i.e., your application doesn't require a logged-in Spotify user, set this to YES.
    [self.rootViewController presentViewController:loginViewController animated:YES completion:nil];
}

#pragma mark - Root

- (MSDynamicsDrawerViewController*)rootViewController
{
    if (_rootViewController) {
        return _rootViewController;
    }
    _rootViewController = [[MSDynamicsDrawerViewController alloc] init];
    _rootViewController.delegate = self;
    [_rootViewController setDrawerViewController:self.leftDrawerViewController
                                    forDirection:MSDynamicsDrawerDirectionLeft];
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:[[TRPTripListViewController alloc] init]];
    navController.navigationBar.translucent = YES;
    navController.navigationBarHidden = YES;
    _rootViewController.paneViewController = navController;

    return _rootViewController;
}

- (BOOL)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController
                  shouldBeginPanePan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UINavigationController *rootNavigationController = (UINavigationController*)drawerViewController.paneViewController;
    return [rootNavigationController.viewControllers count] == 1;
}

#pragma mark - Left Drawer

- (TRPLeftDrawerViewController*)leftDrawerViewController
{
    if (_leftDrawerViewController) {
        return _leftDrawerViewController;
    }

    _leftDrawerViewController = [[TRPLeftDrawerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _leftDrawerViewController.delegate = self;

    return _leftDrawerViewController;
}

- (void)logout:(dispatch_block_t)completion
{
    [self.authController logout:completion];
    [self.rootViewController setPaneState:MSDynamicsDrawerPaneStateClosed
                                 animated:YES
                    allowUserInterruption:NO
                               completion:nil];
}

#pragma mark - Auth

- (TRPAuthController*)authController
{
    if (_authController) {
        return _authController;
    }
    _authController = [TRPAuthController new];
    [[SPSession sharedSession] setDelegate:_authController];
    _authController.delegate = self;
    return _authController;
}

- (void)didLoginWithUser:(SPUser *)user
{
    self.leftDrawerViewController.user = user;

    UINavigationController *rootNavigationController = (UINavigationController*)[self.rootViewController paneViewController];
    TRPTripListViewController *tripListViewController = (TRPTripListViewController*)
    [[rootNavigationController viewControllers] firstObject];

    SimpleTripStorage *storage = [[SimpleTripStorage alloc] initWithUserID:user.canonicalName];
    if ([tripListViewController.tripStorage isEqual:storage]) {
        return;
    }

    [rootNavigationController popToRootViewControllerAnimated:NO];

    TRPMutableTripModel *dummyTrip1 = [[TRPMutableTripModel alloc] init];
    [dummyTrip1 setLocation:@"Miami"];

    TRPMutableTripModel *dummyTrip2 = [[TRPMutableTripModel alloc] init];
    [dummyTrip2 setLocation:@"New York"];
    [storage saveTrips:@[dummyTrip1, dummyTrip2]];

    tripListViewController.tripStorage = storage;
}

- (void)didLogout
{
    [self showLoginViewController];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // set status bar to white text
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[self class] configureSharedSpotifySession];
    [[self class] configureEchoNestAPI];

    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];

    if ([[self authController] loginWithStoredCredentials]) {
        return YES;
    }

    // fix unbalanced calls to rootViewController begin/end appearance
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLoginViewController];
    });

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
