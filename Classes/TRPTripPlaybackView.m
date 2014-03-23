//
//  TRPTripPlaybackView.m
//  Tripster
//
//  Created by Rob Rehrig on 3/23/14.
//  Copyright (c) 2014 UMiami. All rights reserved.
//

#import "TRPTripPlaybackView.h"

@implementation TRPTripPlaybackView
@synthesize trackTitle = _trackTitle;
@synthesize trackArtist = _trackArtist;
@synthesize coverView = _coverView;
@synthesize positionSlider = _positionSlider;
@synthesize volumeSlider = _volumeSlider;
@synthesize playbackManager = _playbackManager;
@synthesize currentTrack = _currentTrack;
@synthesize playButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.trackTitle = [[UILabel alloc] init];
        [self addSubview:self.trackTitle];
        
        self.trackArtist = [[UILabel alloc] init];
        [self addSubview:self.trackArtist];
        
        self.coverView =[[UIImageView alloc] init];
        [self addSubview:self.coverView];
        
        self.positionSlider = [[UISlider alloc] init];
        [self.positionSlider addTarget:self action:@selector(setTrackPosition:) forControlEvents:UIControlEventValueChanged];
        self.positionSlider.minimumValue = 0.0;
        self.positionSlider.maximumValue = 1.0;
        self.positionSlider.continuous = YES;
        self.positionSlider.value = 0.0;
        [self addSubview:self.positionSlider];
        
        self.volumeSlider = [[UISlider alloc] init];
        [self.volumeSlider addTarget:self action:@selector(setVolume:) forControlEvents:UIControlEventValueChanged];
        self.volumeSlider.minimumValue = 0.0;
        self.volumeSlider.maximumValue = 1.0;
        self.volumeSlider.continuous = YES;
        self.volumeSlider.value = 1.0;
        [self addSubview:self.volumeSlider];
        
        self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
        [[SPSession sharedSession] setDelegate:self];
        trackUrlBuffer = [[NSMutableArray alloc]  init];
        [self addObserver:self forKeyPath:@"currentTrack.name" options:0 context:nil];
        [self addObserver:self forKeyPath:@"currentTrack.artists" options:0 context:nil];
        [self addObserver:self forKeyPath:@"currentTrack.duration" options:0 context:nil];
        [self addObserver:self forKeyPath:@"currentTrack.album.cover.image" options:0 context:nil];
        [self addObserver:self forKeyPath:@"playbackManager.trackPosition" options:0 context:nil];
        
        [self.playbackManager setDelegate:self];
        tripModel = [TRPMutableTripModel getTripModel];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.trackTitle setText:@"Track Title"];
    self.trackTitle.textAlignment = NSTextAlignmentCenter;
    self.trackTitle.frame = CGRectMake(0.0, 100.0, self.bounds.size.width, 20.0);
    
    [self.trackArtist setText:@"Track Artist"];
    self.trackArtist.textAlignment = NSTextAlignmentCenter;
    self.trackArtist.frame = CGRectMake(0.0, 120.0, self.bounds.size.width, 20.0);
    
    self.coverView.frame = CGRectMake((self.bounds.size.width - 150.0)/2.0, 140.0, 150.0, 150.0);
    [self.coverView setBackgroundColor:[UIColor grayColor]];
    
    self.positionSlider.frame = CGRectMake(20.0, 310.0, self.bounds.size.width - 40.0, 20.0);
    
    self.volumeSlider.frame = CGRectMake(20.0, 340.0, self.bounds.size.width - 40.0, 20.0);
    
    self.playButton.frame = CGRectMake((self.bounds.size.width - 150.0)/2.0, 80.0, 50.0, 20.0);
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    
    [self createSessionWithArtists:[tripModel chosenSeeds]];
    BOOL didSucceedNewTracks = [self getSongsForCurrentSession];
    if(!didSucceedNewTracks)
        NSLog(@"No new tracks recieved");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentTrack.name"]) {
        self.trackTitle.text = self.currentTrack.name;
	} else if ([keyPath isEqualToString:@"currentTrack.artists"]) {
		self.trackArtist.text = [[self.currentTrack.artists valueForKey:@"name"] componentsJoinedByString:@","];
	} else if ([keyPath isEqualToString:@"currentTrack.album.cover.image"]) {
		self.coverView.image = self.currentTrack.album.cover.image;
	} else if ([keyPath isEqualToString:@"currentTrack.duration"]) {
		self.positionSlider.maximumValue = self.currentTrack.duration;
	} else if ([keyPath isEqualToString:@"playbackManager.trackPosition"]) {
		// Only update the slider if the user isn't currently dragging it.
		if (!self.positionSlider.highlighted)
			self.positionSlider.value = self.playbackManager.trackPosition;
        //        if (self.positionSlider.value==self.positionSlider.maximumValue) {
        //            [self getSongsForCurrentSession];
        //        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (IBAction)playButtonPressed:(id)sender {
	// Invoked by clicking the "Play" button in the UI.
	NSString *trackurlstring = [[trackUrlBuffer objectAtIndex:[trackUrlBuffer count]-1] stringByReplacingOccurrencesOfString:@"-US" withString:@""];
	if (trackurlstring.length > 0) {
		
		NSURL *trackURL = [NSURL URLWithString:trackurlstring];
		[[SPSession sharedSession] trackForURL:trackURL callback:^(SPTrack *track) {
			
			if (track != nil) {
				
				[SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
					[self.playbackManager playTrack:track callback:^(NSError *error) {
						
						if (error) {
							UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
																			message:[error localizedDescription]
																		   delegate:nil
																  cancelButtonTitle:@"OK"
																  otherButtonTitles:nil];
							[alert show];
						} else {
							self.currentTrack = track;
						}
						
					}];
				}];
			}
		}];
		
		return;
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
													message:@"Please enter a track URL"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

- (IBAction)setTrackPosition:(id)sender {
	[self.playbackManager seekToTrackPosition:self.positionSlider.value];
}

- (IBAction)setVolume:(id)sender {
	self.playbackManager.volume = [(UISlider *)sender value];
}

-(void)didReceiveNextSong:(NSString *)urlString{
    [trackUrlBuffer addObject:urlString];
}






//



- (void) createSessionWithArtists:(NSArray*) artists{
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    canRequestTrack = false;
    requestType = @"StartSession";
    
    NSString *endPoint = @"playlist/dynamic/create";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    [request setDelegate:self];
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"id:spotify-US", @"tracks",nil];
    [request setValue:artists forParameter:@"artist"];
    [request setValue:bucket forParameter:@"bucket"];
    [request startSynchronous];
}

/* returns true if songs can be requested. returns false if songs cannot be requested. */
- (bool) getSongsForCurrentSession{
    
    if(canRequestTrack){
        requestType = @"NextSong";
        // Get Next Song!
        NSString *endPoint = @"playlist/dynamic/next";
        ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
        [request setDelegate:self];
        [request setIntegerValue:1 forParameter:@"results"];
        [request setIntegerValue:0 forParameter:@"lookahead"]; // Look Aheads do anything for us ???
        [request setValue:sessionID forParameter:@"session_id"];
        [self.positionSlider setValue:0];
        [request startSynchronous];
        return true;
    }
    
    return false;
}

- (void) requestFailed:(ENAPIRequest *)request{
    //    if([delegate respondsToSelector:@selector(failedToCreatePlaylist)]){
    //        [delegate failedToCreatePlaylist];
    //    }
}

- (void) requestFinished:(ENAPIRequest *)request{
    
    NSDictionary *response;
    if([requestType isEqualToString:@"StartSession"]){
        response = [[request response] objectForKey:@"response"];
        sessionID = [response objectForKey:@"session_id"];
        canRequestTrack = true;
        //        if([delegate respondsToSelector:@selector(successfullyCreatedPlaylist)]){
        //            [delegate successfullyCreatedPlaylist];
        //        }
    } else if([requestType isEqualToString:@"NextSong"]){
        response = [[request response] objectForKey:@"response"]; // contains Song and Look Ahead
        NSArray *songs = [response objectForKey:@"songs"];
        if([songs count] > 0){
            NSString *spotifyID = [[[[songs objectAtIndex:0] objectForKey:@"tracks"] objectAtIndex:0] objectForKey:@"foreign_id"];
            [self didReceiveNextSong:spotifyID];
            
            
        }
        // NSArray *lookAhead = [response objectForKey:@"lookahead"];
        
    }
}
-(void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager{
    //bullshit people writing delegate methods that don't check for implementation before sending unrecognized selectors making me do shit like leave empty implementations of methods :)
}

-(void)sessionDidEndPlayback{
    BOOL didSucceedNewTracks = [self getSongsForCurrentSession];
    if(!didSucceedNewTracks){
        NSLog(@"No new tracks recieved");
        // Error handling?
    }
    [self playButtonPressed:nil];
}


@end
