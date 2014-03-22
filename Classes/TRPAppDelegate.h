//
//  TRPAppDelegate.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import <CocoaLibSpotify/SPLoginViewController.h>

@interface TRPAppDelegate : UIResponder <UIApplicationDelegate, SPLoginViewControllerDelegate>
{
    //LoginViewController *LVC; // Replaced by SPLVC
    SPLoginViewController *loginViewController; // Login VC
    SPSession *session;
}

@property (strong, nonatomic) UIWindow *window;

@end
