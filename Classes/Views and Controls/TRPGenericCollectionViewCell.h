//
//  TRPTripCollectionViewCell.h
//  Tripster
//
//  Created by Brian Gerstle on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRPGenericCollectionViewCell : UICollectionViewCell

- (void)setTitle:(NSString*)title;
- (void)setTitleFont:(UIFont*)font;

- (void)setSubtitle:(NSString*)subtitle;
- (void)setSubtitleFont:(UIFont*)font;

- (void)setBackgroundImageURL:(NSURL*)backgroundImageURL;

@end
