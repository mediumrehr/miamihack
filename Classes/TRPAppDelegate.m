//
//  TRPAppDelegate.m
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPAppDelegate.h"
#import "LoginViewController.h"
#import "TRPConstants.h"
#import <CocoaLibSpotify.h>
#import <SPPlaybackManager.h>

#define kDefaultSpotifyUserCredentials @"DefaultSpotifyUserCredentials"

@interface TRPAppDelegate ()
<UIApplicationDelegate, SPSessionDelegate>
@property (strong, nonatomic) SPPlaybackManager *playbackManager;
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

- (BOOL)maybeAutologin
{
    NSDictionary* user = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kDefaultSpotifyUserCredentials];
    if (!user) {
        return NO;
    }

    [[SPSession sharedSession] attemptLoginWithUserName:[[user allKeys] lastObject]
                                     existingCredential:[[user allValues] lastObject]];

    // TODO: show modal login activity indicator
//    [MBProgressHUD showHUDAddedTo:_rootVC.view animated:NO];

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[self class] configureSharedSpotifySession];

    [[SPSession sharedSession] setDelegate:self];

    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];

    if ([self maybeAutologin]) {
        return YES;
    }

    SPLoginViewController *loginViewController = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
    // To allow the user to cancel (i.e., your application doesn't require a logged-in Spotify user, set this to YES.
    loginViewController.allowsCancel = NO;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = loginViewController;
    [self.window makeKeyAndVisible];

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

#pragma mark SPSessionDelegate Methods

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession {
	// Called after a successful login.

//    [MBProgressHUD hideAllHUDsForView:_rootVC.view animated:YES];

	[SPAsyncLoading waitUntilLoaded:aSession timeout:kSPAsyncLoadingDefaultTimeout then:^
     (NSArray *loadedItems, NSArray *notLoadedItems) {
         if (![loadedItems containsObject:aSession]) {
             [NSException raise:@"Session failed to load" format:@"Not loaded items %@", notLoadedItems];
         }

         // go to main UI

         [SPAsyncLoading waitUntilLoaded:aSession.user timeout:kSPAsyncLoadingDefaultTimeout then:^
          (NSArray *loadedItems, NSArray *notLoadedItems) {
              if (![loadedItems containsObject:aSession.user]) {
                  [NSException raise:@"Session user failed to load" format:@"Not loaded items %@", notLoadedItems];
              }

              // do stuff w/ user
          }];
     }];
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error {
	// Called after a failed login. SPLoginViewController will deal with this for us.
    if ([self.window.rootViewController isKindOfClass:[SPLoginViewController class]]) {
        return;
    }

    SPLoginViewController *controller = [SPLoginViewController loginControllerForSession:[SPSession sharedSession]];
    controller.allowsCancel = NO;
    controller.dismissesAfterLogin = YES;
    // ^ To allow the user to cancel (i.e., your application doesn't require a logged-in Spotify user, set this to YES.
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

-(void)sessionDidLogOut:(SPSession *)aSession; {
	// Called after a logout has been completed.
}

-(void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName {

	// Called when login credentials are created. If you want to save user logins, uncomment the code below.

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *storedCredentials = [[defaults valueForKey:kDefaultSpotifyUserCredentials] mutableCopy];

	if (storedCredentials == nil)
		storedCredentials = [NSMutableDictionary dictionary];

	[storedCredentials setValue:credential forKey:userName];
	[defaults setValue:storedCredentials forKey:kDefaultSpotifyUserCredentials];
}

-(void)sessionDidChangeMetadata:(SPSession *)aSession; {
	// Called when metadata has been updated somewhere in the
	// CocoaLibSpotify object model. You don't normally need to do
	// anything here. KVO on the metadata you're interested in instead.
}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
	// Called when the Spotify service wants to relay a piece of information to the user.
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"From Spotify"
													message:aMessage
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}


@end
