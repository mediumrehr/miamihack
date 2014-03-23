//
//  TRPColorPicker.h
//  Tripster
//
//  Created by Marko Gill on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRPColorPicker : NSObject

+ (UIColor *) getMainColorFromImage:(UIImage *)image;
@end

@interface PCCountedColor : NSObject

@property (assign) NSUInteger count;
@property (retain) UIColor *color;

- (id)initWithColor:(UIColor*)color count:(NSUInteger)count;

@end