//
//  ArtistModel.h
//  Tripster
//
//  Created by Andrew Ayers on 3/22/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <libechonest/ENAPI.h>
#import "TRPConstants.h"

@protocol ArtistModelDelegate <NSObject>

@optional
-(void)didReceiveArtistModel:(NSArray *)artists withMessage:(NSString *)message;

@end


@interface ArtistModel : NSObject <ENAPIRequestDelegate>{
//    NSString *location;
//    NSMutableArray *artists;
    ENAPIRequest *request;
}

-(void)createArtistsModelforLocation:(NSString *)location;

@property id delegate;

@end
