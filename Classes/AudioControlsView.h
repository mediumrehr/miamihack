//
//  AudioControlsView.h
//  ReLOADWireframe
//
//  Created by Fore Center on 2/19/14.
//  Copyright (c) 2014 Rob Rehrig. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AudioControlViewDelegate <NSObject>
@optional

-(void)audioButtonPressed:(int)state;

@end

@interface AudioControlsView : UIView
{
    
}
@property (nonatomic, strong) UIButton *button_PlayPause;
@property (nonatomic, strong) UIButton *button_Next;
@property (nonatomic, strong) UIButton *button_Previous;
@property (nonatomic, strong) UILabel  *label_SongTitle;
@property (nonatomic, strong) UILabel  *label_SongArtist;
@property id delegate;
- (void) setPlayPauseButton:(bool) showPlayImage;
- (void) buttonPressed:(id)sender;
@end
