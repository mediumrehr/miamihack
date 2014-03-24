//
//  TRPMutableCollectionViewCell.h
//  Tripster
//
//  Created by Andrew Ayers on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPGenericCollectionViewCell.h"

@interface TRPMutableCollectionViewCell : TRPGenericCollectionViewCell <UITextFieldDelegate>
-(void)startEditing;
-(void)showLocationButton:(BOOL)isShowing;
@property (nonatomic, strong) UITextField *titleLabel;


@end
