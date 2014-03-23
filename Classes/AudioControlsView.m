//
//  AudioControlsView.m
//  ReLOADWireframe
//
//  Created by Fore Center on 2/19/14.
//  Copyright (c) 2014 Rob Rehrig. All rights reserved.
//

#import "AudioControlsView.h"

@implementation AudioControlsView

@synthesize button_Next,button_PlayPause,button_Previous, label_SongTitle, label_SongArtist, delegate;

- (void) initialize
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    /* ----- Buttons ----- */
    button_PlayPause = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    int playButtonX = (self.frame.size.width/2) - 18;
    button_PlayPause.frame = CGRectMake(playButtonX, self.frame.size.height - 37, 36, 32);
    [button_PlayPause setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self addSubview:button_PlayPause];
    [button_PlayPause addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Initialization code
    button_Previous = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button_Previous.frame = CGRectMake(playButtonX - 75 + 9, self.frame.size.height - 37, 24, 32);
    [button_Previous setBackgroundImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [self addSubview:button_Previous];
    [button_Previous addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    button_Next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button_Next.frame = CGRectMake(playButtonX + 75, self.frame.size.height - 37, 24, 32);
    [button_Next setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [self addSubview:button_Next];
    [button_Next addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    /* ----- Labels ----- */
    label_SongTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    [label_SongTitle setTextAlignment:NSTextAlignmentCenter];
    [label_SongTitle setTextColor:[UIColor darkGrayColor]];
    [self addSubview:label_SongTitle];
    
    label_SongArtist = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, self.frame.size.width, 20)];
    [label_SongArtist setFont:[[label_SongArtist font] fontWithSize:15]];
    [label_SongArtist setTextAlignment:NSTextAlignmentCenter];
    [label_SongArtist setTextColor:[UIColor darkGrayColor]];
    [self addSubview:label_SongArtist];      
    
    //self.layer.cornerRadius = 4;
    //self.layer.borderWidth = 1;
    //self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [[self layer] setMasksToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    
    
}
- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (void) buttonPressed:(id)sender
{
    
    if(sender == button_Previous){
        // Want this?
        [delegate audioButtonPressed:0];
    } else if(sender == button_PlayPause){
        // call setPlayPauseButton please
        [delegate audioButtonPressed:1];
    } else if(sender == button_Next){
        [delegate audioButtonPressed:2];
    }
}

- (void) setPlayPauseButton:(bool) showPlayImage
{
    if(showPlayImage){
        [button_PlayPause setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        int playButtonX = (self.frame.size.width/2) - 18;
        button_PlayPause.frame = CGRectMake(playButtonX, self.frame.size.height - 37, 36, 32);
    } else{
        int playButtonX = (self.frame.size.width/2) - 12;
        button_PlayPause.frame = CGRectMake(playButtonX, self.frame.size.height - 37, 24, 32);
        [button_PlayPause setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}
@end
