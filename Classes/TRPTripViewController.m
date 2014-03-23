//
//  TRPTripViewController.m
//  
//
//  Created by Andrew Ayers on 3/22/14.
//
//

#import "TRPTripViewController.h"


@interface TRPTripViewController ()

@end

@implementation TRPTripViewController

@synthesize trackTitle = _trackTitle;
@synthesize trackArtist = _trackArtist;
@synthesize coverView = _coverView;
@synthesize positionSlider = _positionSlider;
@synthesize playbackManager = _playbackManager;
@synthesize currentTrack = _currentTrack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
        //plModel = [[TRPPlaylistModel alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // [plModel createSessionWithArtists:[tripModel chosenSeeds]];
    [self createSessionWithArtists:[tripModel chosenSeeds]];
   BOOL didSucceedNewTracks = [self getSongsForCurrentSession];
    if(!didSucceedNewTracks){
        NSLog(@"No new tracks recieved");
        // Error handling?
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            
        } else if([requestType isEqualToString:@"genrePlaylist"]){
            NSMutableArray *genrePlaylist = [[NSMutableArray alloc] init];
            response = [[request response] objectForKey:@"response"];
            if(request.responseStatusCode == 200){ // Successful query
                NSArray *songs = [response objectForKey:@"songs"];
                // --- EXTRACT SPOTIFY ID ---
                for(int i = 0; i < [songs count]; i++){
                    NSDictionary *song = [songs objectAtIndex:i];
                    NSArray *tracks = [song objectForKey:@"tracks"];
                    NSDictionary *track = [tracks objectAtIndex:0];
                    NSString *spotify_ID = [track objectForKey:@"foreign_id"]; // send this to spotify
                    [genrePlaylist addObject:spotify_ID];
                    NSLog(@"Print ID: %@",spotify_ID);
                }
                // --- EXTRACT SPOTIFY ID ---
            }

        }
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

- (void) getGenreRadioPlaylistWithGenres:(NSArray*)genres{
    [ENAPI initWithApiKey:kEchoNestAPIKey
              ConsumerKey:kEchoNestConsumerKey
          AndSharedSecret:kEchoNestSharedSecret];
    
    requestType = @"genrePlaylist";
    NSString *endPoint = @"playlist/static";
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:endPoint];
    NSArray *bucket = [[NSArray alloc] initWithObjects: @"id:spotify-US", @"tracks",nil];
    [request setIntegerValue:100 forParameter:@"results"];
    [request setValue:genres forParameter:@"genre"];
    [request setValue:@"genre-radio" forParameter:@"type"];
    [request setValue:bucket forParameter:@"bucket"];
    [request startAsynchronous];
}

@end
