//
//  TRPAuthController.m
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPAuthController.h"

#define kDefaultSpotifyUserCredentials @"DefaultSpotifyUserCredentials"

@interface TRPAuthController ()

@end

@implementation TRPAuthController

- (void)logout:(dispatch_block_t)completion
{
    [[SPSession sharedSession] logout:completion];
}

- (BOOL)loginWithStoredCredentials
{
    NSDictionary* user = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kDefaultSpotifyUserCredentials];
    if (!user) {
        return NO;
    }
    [[SPSession sharedSession] attemptLoginWithUserName:[[user allKeys] lastObject]
                                     existingCredential:[[user allValues] lastObject]];
    return YES;
}


#pragma mark SPSessionDelegate

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    @weakify(self);
	[SPAsyncLoading waitUntilLoaded:aSession timeout:kSPAsyncLoadingDefaultTimeout then:^
     (NSArray *loadedItems, NSArray *notLoadedItems) {
         if (![loadedItems containsObject:aSession]) {
             [NSException raise:@"Session failed to load" format:@"Not loaded items %@", notLoadedItems];
         }
         @strongify(self);
         [self.delegate didLoginWithUser:aSession.user];
     }];
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
	// Called after a failed login. SPLoginViewController will deal with this for us.
    if ([self.delegate respondsToSelector:@selector(loginDidFail:)]) {
        [self.delegate loginDidFail:error];
    }
}

- (void)sessionDidLogOut:(SPSession *)aSession
{
	// Called after a logout has been completed.
    [self.delegate didLogout];
}

- (void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *storedCredentials = [[defaults valueForKey:kDefaultSpotifyUserCredentials] mutableCopy];

	if (storedCredentials == nil)
		storedCredentials = [NSMutableDictionary dictionary];

	[storedCredentials setValue:credential forKey:userName];
	[defaults setValue:storedCredentials forKey:kDefaultSpotifyUserCredentials];
}

//- (void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage
//{
//	// Called when the Spotify service wants to relay a piece of information to the user.
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"From Spotify"
//													message:aMessage
//												   delegate:nil
//										  cancelButtonTitle:@"OK"
//										  otherButtonTitles:nil];
//	[alert show];
//}

@end
