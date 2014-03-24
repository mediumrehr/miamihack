//
//  ENSPAggregateArtist.m
//  Tripster
//
//  Created by Brian Gerstle on 3/24/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "ENSPAggregateArtist.h"
#import <CocoaLibSpotify/SPSession.h>

@implementation ENSPAggregateArtist

- (NSUInteger)hash
{
    return [_enArtistID hash];
}

+ (void)loadSpotifyArtistFromENArtistData:(NSDictionary*)artistData completion:(void(^)(SPArtist*))completion
{
    NSString *spotifyArtistID = [[[[artistData[@"foreign_ids"] rac_sequence]
                                   filter:^BOOL(NSDictionary *foreignID) {
                                       return [foreignID[@"catalog"] isEqualToString:@"spotify-US"];
                                   }]
                                  array] firstObject][@"foreign_id"];

    spotifyArtistID = [[spotifyArtistID componentsSeparatedByString:@":"] lastObject];

    NSURL *spotifyArtistURL = [NSURL URLWithString:
                               [NSString stringWithFormat:@"spotify:artist:%@",spotifyArtistID]];
    [SPArtist artistWithArtistURL:spotifyArtistURL
                        inSession:[SPSession sharedSession] callback:completion];
}

@end
