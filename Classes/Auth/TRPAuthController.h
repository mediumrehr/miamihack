//
//  TRPAuthController.h
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/SPSession.h>

@class SPUser;
@protocol TRPAuthControllerDelegate <NSObject>

- (void)didLoginWithUser:(SPUser*)user;

- (void)didLogout;

@optional
- (void)loginDidFail:(NSError*)error;

@end

@interface TRPAuthController : NSObject
<SPSessionDelegate>
@property (nonatomic, weak) id<TRPAuthControllerDelegate> delegate;

- (BOOL)loginWithStoredCredentials;

- (void)logout:(dispatch_block_t)completion;

@end
