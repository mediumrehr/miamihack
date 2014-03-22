//
//  NSArray+ENAPI.m
//  libechonest
//
//  Copyright (c) 2011, tapsquare, llc. (http://www.tapsquare.com, art@tapsquare.com)
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//   * Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   * Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//   * Neither the name of the tapsquare, llc nor the names of its contributors
//     may be used to endorse or promote products derived from this software
//     without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL TAPSQUARE, LLC. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSArray+ENAPI.h"
#import "NSObject+SBJSON.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation NSArray (NSArray_ENAPI)

- (NSString *)enapi_catalogUpdateBlockWithAction:(NSString *)action {
    // first create the array of "item" dictionaries
    NSMutableArray *f_items = [NSMutableArray arrayWithCapacity:self.count];
    for (MPMediaItem *item in (NSArray *)self) {
        // see http://developer.echonest.com/docs/v4/catalog.html#update
        
        NSMutableDictionary *block = [NSMutableDictionary dictionaryWithCapacity:4];
        
        [block setValue:[[item valueForProperty:MPMediaItemPropertyPersistentID] descriptionWithLocale:nil] forKey:@"item_id"];
        [block setValue:[item valueForProperty:MPMediaItemPropertyTitle] forKey:@"song_name"];
        [block setValue:[item valueForProperty:MPMediaItemPropertyArtist] forKey:@"artist_name"];
        [block setValue:[item valueForProperty:MPMediaItemPropertyPlayCount] forKey:@"play_count"];
        [block setValue:[item valueForProperty:MPMediaItemPropertySkipCount] forKey:@"skip_count"];
        
        NSMutableDictionary *item_dict = [NSDictionary dictionaryWithObject:block forKey:@"item"];
        if (nil != action) {
            [item_dict setValue:action forKey:@"action"];
        }
        [f_items addObject:item_dict];
    }
    return [f_items JSONRepresentation];
}

@end
