//
// Created by Alexis Kinsella on 28/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MediaPlayer/MediaPlayer.h>
#import <YTVimeoExtractor/YTVimeoExtractor.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "VMVideoDetailsViewController.h"
#import "VMVideo.h"
#import "UIAlertView+XBAdditions.h"
#import "VMThumbnail.h"

@implementation VMVideoDetailsViewController

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = touches.anyObject;

    if (touch.view == self.videoImage) {
        [self videoImageTapped];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    if (self.video) {
        VMThumbnail * thumbnail = self.video.thumbnails[2];
        XBLog(@"Image url: %@", thumbnail.url);
        [self.videoImage setImageWithURL:[NSURL URLWithString:thumbnail.url] placeholderImage:[UIImage imageNamed:@"video_placeholder.png"]
                                 success:^(UIImage *image) {
                                     self.videoImage.image = [self generateWatermarkForImage:image];
                                 }
                                 failure:^(NSError *error) {
                                     XBLog(@"Error: %@", error);
                                 }];
    }
}
-(UIImage *) generateWatermarkForImage:(UIImage *) mainImg {
    UIImage *backgroundImage = mainImg;
    UIImage *watermarkImage = [UIImage imageNamed:@"videoPlayButton.png"];

    //Now re-drawing your  Image using drawInRect method
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    [watermarkImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];

    // now merging two images into one
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

- (void)videoImageTapped {

    [YTVimeoExtractor fetchVideoURLFromID: [NSString stringWithFormat:@"%@", self.video.identifier]
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

-(void)setVideo:(VMVideo *)video {
    _video = video;
    self.title = video.title;
    self.videoImage.image = [UIImage imageNamed:@"video_placeholder.png"];

}

- (void)updateView {
    self.displayName.text = self.video.owner.displayName;
    self.date.text = [self.video dateTimeFormatted];
    self.playCount.text = [NSString stringWithFormat: @"%@", self.video.playCount];
    self.likeCount.text = [NSString stringWithFormat: @"%@", self.video.likeCount];
    self.commentCount.text = [NSString stringWithFormat: @"%@", self.video.commentCount];
    self.definition.text = [NSString stringWithFormat: @"%@", self.video.isHd ? @"HD":@""];
}

/* Called soon after the Play Movie button is pressed to play the streaming movie. */
-(void)playMovieStream:(NSURL *)movieURL
{
    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
    /* If we have a streaming url then specify the movie source type. */
    if ([movieURL.pathExtension compare:@"m3u8" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        movieSourceType = MPMovieSourceTypeStreaming;
    }

    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL: movieURL];
    if (player) {
        player.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        player.moviePlayer.movieSourceType = movieSourceType;
        player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        player.moviePlayer.backgroundView.backgroundColor = [UIColor blackColor];
        player.moviePlayer.repeatMode = MPMovieRepeatModeNone;
        player.moviePlayer.useApplicationAudioSession = YES;

        /* Indicate the movie player allows AirPlay movie playback. */
        player.moviePlayer.allowsAirPlay = YES;

        [self presentMoviePlayerViewControllerAnimated:player];
    }

}

@end



