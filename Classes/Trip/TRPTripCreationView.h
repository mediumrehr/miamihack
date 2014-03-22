//
//  TRPTripCreationView.h
//  Tripster
//
//  Created by Brian Gerstle on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistModel.h"

@interface TRPTripCreationView : UIView <UITextFieldDelegate, ArtistModelDelegate>{
    ArtistModel *artistModel;
}

@end
