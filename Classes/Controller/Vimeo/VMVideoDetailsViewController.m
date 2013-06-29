//
// Created by Alexis Kinsella on 28/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MediaPlayer/MediaPlayer.h>
#import <YTVimeoExtractor/YTVimeoExtractor.h>
#import "VMVideoDetailsViewController.h"
#import "VMVideo.h"
#import "UIAlertView+XBAdditions.h"

CGFloat kMovieViewOffsetX = 20.0;
CGFloat kMovieViewOffsetY = 20.0;

@interface VMVideoDetailsViewController ()
-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType;
-(void)applyUserSettingsToMoviePlayer;
-(void)moviePlayBackDidFinish:(NSNotification*)notification;
-(void)loadStateDidChange:(NSNotification *)notification;
-(void)moviePlayBackStateDidChange:(NSNotification*)notification;
-(void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification;
-(void)installMovieNotificationObservers;
-(void)removeMovieNotificationHandlers;
-(void)deletePlayerAndNotificationObservers;
-(void)removeMovieViewFromViewHierarchy;

@end

@implementation VMVideoDetailsViewController

#pragma mark View Controller

-(void)setVideo:(VMVideo *)video {
    _video = video;
    self.title = video.title;

    [YTVimeoExtractor fetchVideoURLFromID: [NSString stringWithFormat:@"%@", video.identifier]
                                  quality:YTVimeoVideoQualityMedium
                                  success:^(NSURL *videoURL) {
                                      NSLog(@"Video URL: %@", [videoURL absoluteString]);
                                      [self updateView];
                                      [self playMovieStream:videoURL];
                                  }
                                  failure:^(NSError *error) {
                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erreur", nil)
                                                                                          message:[error description]
                                                                                         delegate:nil
                                                                                cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                                                otherButtonTitles:nil];

                                      [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) { }];
                                  }
    ];

}

- (void)updateView {
    self.displayName.text = self.video.owner.displayName;
    self.date.text = [self.video dateTimeFormatted];
    self.playCount.text = [NSString stringWithFormat: @"%@", self.video.playCount];
    self.likeCount.text = [NSString stringWithFormat: @"%@", self.video.likeCount];
    self.commentCount.text = [NSString stringWithFormat: @"%@", self.video.commentCount];
    self.definition.text = [NSString stringWithFormat: @"%@", self.video.isHd ? @"HD":@""];
}

/* Sent to the view controller after the user interface rotates. */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateVideoPlayerPosition];
}

-(void)updateVideoPlayerPosition {
    /* Size movie view to fit parent view. */
    if (self.moviePlayerController) {
        CGRect viewInsetRect = CGRectMake(
                                          self.videoBackgroundView.frame.origin.x,
                                          self.videoBackgroundView.frame.origin.y,
                                          self.videoBackgroundView.frame.size.width,
                                          self.videoBackgroundView.frame.size.height
                                          );
        self.moviePlayerController.view.frame = viewInsetRect;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    /* Return YES for supported orientations. */
    return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidUnload
{
    [self deletePlayerAndNotificationObservers];

    [self setVideoBackgroundView:nil];
    [self setPlayCount:nil];
    [self setLikeCount:nil];
    [self setCommentCount:nil];
    [self setTitle:nil];
    [self setDefinition:nil];
    [self setDate:nil];
    [super viewDidUnload];
}

/* Notifies the view controller that its view is about to be become visible. */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    /* Update user settings for the movie (in case they changed). */
    [self applyUserSettingsToMoviePlayer];
}

/* Notifies the view controller that its view is about to be dismissed,
 covered, or otherwise hidden from view. */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* Remove the movie view from the current view hierarchy. */
    [self removeMovieViewFromViewHierarchy];

    /* Delete the movie player object and remove the notification observers. */
    [self deletePlayerAndNotificationObservers];
}

/* Remove the movie view from the view hierarchy. */
-(void)removeMovieViewFromViewHierarchy
{
    MPMoviePlayerController *player = [self moviePlayerController];

    [player.view removeFromSuperview];
}

#pragma mark Error Reporting

-(void)displayError:(NSError *)theError
{
    if (theError)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                initWithTitle: @"Error"
                      message: [theError localizedDescription]
                     delegate: nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        [alert show];
    }
}

/*
 Called by the MoviePlayerAppDelegate (UIApplicationDelegate protocol)
 applicationWillEnterForeground when the app is about to enter
 the foreground.
 */
- (void)viewWillEnterForeground
{
    /* Set the movie object settings (control mode, background color, and so on)
       in case these changed. */
    [self applyUserSettingsToMoviePlayer];
}

#pragma mark Play Movie Actions

/* Called soon after the Play Movie button is pressed to play the local movie. */
-(void)playMovieFile:(NSURL *)movieFileURL
{
    [self createAndPlayMovieForURL:movieFileURL sourceType:MPMovieSourceTypeFile];
}

/* Called soon after the Play Movie button is pressed to play the streaming movie. */
-(void)playMovieStream:(NSURL *)movieFileURL
{
    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
    /* If we have a streaming url then specify the movie source type. */
    if ([[movieFileURL pathExtension] compare:@"m3u8" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        movieSourceType = MPMovieSourceTypeStreaming;
    }
    [self createAndPlayMovieForURL:movieFileURL sourceType:movieSourceType];
}

#pragma mark Create and Play Movie URL

/*
 Create a MPMoviePlayerController movie object for the specified URL and add movie notification
 observers. Configure the movie object for the source type, scaling mode, control style, background
 color, background image, repeat mode and AirPlay mode. Add the view containing the movie content and
 controls to the existing view hierarchy.
 */
-(void)createAndConfigurePlayerWithURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    /* Create a new movie player object. */
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];

    if (player)
    {
        /* Save the movie object. */
        [self setMoviePlayerController:player];

        /* Register the current object as an observer for the movie
         notifications. */
        [self installMovieNotificationObservers];

        /* Specify the URL that points to the movie file. */
        [player setContentURL:movieURL];

        /* If you specify the movie type before playing the movie it can result
         in faster load times. */
        [player setMovieSourceType:sourceType];

        /* Apply the user movie preference settings to the movie player object. */
        [self applyUserSettingsToMoviePlayer];

        [self updateVideoPlayerPosition];

        [player view].backgroundColor = [UIColor lightGrayColor];

        /* To present a movie in your application, incorporate the view contained
         in a movie player’s view property into your application’s view hierarchy.
         Be sure to size the frame correctly. */
        [self.view addSubview: [player view]];
    }
}

/* Load and play the specified movie url with the given file type. */
-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    [self createAndConfigurePlayerWithURL:movieURL sourceType:sourceType];

    /* Play the movie! */
    [[self moviePlayerController] play];
}

#pragma mark Movie Notification Handlers

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason integerValue])
    {
        /* The end of the movie was reached. */
        case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            break;

            /* An error was encountered during playback. */
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"]
                                waitUntilDone:NO];
            [self removeMovieViewFromViewHierarchy];
            break;

            /* The user stopped playback. */
        case MPMovieFinishReasonUserExited:
            [self removeMovieViewFromViewHierarchy];
            break;

        default:
            break;
    }
}

/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerController *player = notification.object;
    MPMovieLoadState loadState = player.loadState;

    /* The load state is not known at this time. */
    if (loadState & MPMovieLoadStateUnknown) {
        NSLog(@"unknown");
    }

    /* The buffer has enough data that playback can begin, but it
     may run out of data before playback finishes. */
    if (loadState & MPMovieLoadStatePlayable) {
        NSLog(@"playable");
    }

    /* Enough data has been buffered for playback to continue uninterrupted. */
    if (loadState & MPMovieLoadStatePlaythroughOK) {
        NSLog(@"playthrough ok");
    }

    /* The buffering of data has stalled. */
    if (loadState & MPMovieLoadStateStalled) {
        NSLog(@"stalled");
    }
}

/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
    MPMoviePlayerController *player = notification.object;

    /* Playback is currently stopped. */
    if (player.playbackState == MPMoviePlaybackStateStopped) {
        NSLog(@"stopped");
    }
            /*  Playback is currently under way. */
    else if (player.playbackState == MPMoviePlaybackStatePlaying) {
        NSLog(@"playing");
    }
            /* Playback is currently paused. */
    else if (player.playbackState == MPMoviePlaybackStatePaused) {
        NSLog(@"paused");
    }
            /* Playback is temporarily interrupted, perhaps because the buffer
             ran out of content. */
    else if (player.playbackState == MPMoviePlaybackStateInterrupted) {
        NSLog(@"interrupted");
    }
}

/* Notifies observers of a change in the prepared-to-play state of an object
 conforming to the MPMediaPlayback protocol. */
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    // Add an overlay view on top of the movie view
    NSLog(@"Media is prepared to play");
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = [self moviePlayerController];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = [self moviePlayerController];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

/* Delete the movie player object, and remove the movie notification observers. */
-(void)deletePlayerAndNotificationObservers
{
    [self removeMovieNotificationHandlers];
    [self setMoviePlayerController:nil];
}

#pragma mark Movie Settings

/* Apply user movie preference settings (these are set from the Settings: iPhone Settings->Movie Player)
   for scaling mode, control style, background color, repeat mode, application audio session, background
   image and AirPlay mode.
 */
-(void)applyUserSettingsToMoviePlayer
{
    MPMoviePlayerController *player = [self moviePlayerController];
    if (player)
    {
        player.scalingMode = MPMovieScalingModeAspectFit;
        player.controlStyle = MPMovieControlStyleEmbedded;
        player.backgroundView.backgroundColor = [UIColor blackColor];
        player.repeatMode = MPMovieRepeatModeNone;
        player.useApplicationAudioSession = YES;

        /* Indicate the movie player allows AirPlay movie playback. */
        player.allowsAirPlay = YES;
    }
}

@end



