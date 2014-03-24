//
//  DDLog+Utils.m
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "DDLog+Utils.h"
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>

@implementation DDLog (Utils)

+ (void)load
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end
