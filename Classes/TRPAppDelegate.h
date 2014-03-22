//
//  TRPAppDelegate.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENAPIPostRequest.h"
#import "ENAPIRequest.h"
#import "ENAPI.h"

@interface TRPAppDelegate : UIResponder <UIApplicationDelegate, ENAPIRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
