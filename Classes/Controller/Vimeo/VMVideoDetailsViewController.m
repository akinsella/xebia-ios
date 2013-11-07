//
// Created by Alexis Kinsella on 28/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MediaPlayer/MediaPlayer.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "VMVideoDetailsViewController.h"
#import "VMVideo.h"
#import "UIAlertView+XBAdditions.h"
#import "VMThumbnail.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"
#import "NSDate+XBAdditions.h"
#import "Underscore.h"
#import "VMVideoUrl.h"

@interface VMVideoDetailsViewController()

@property(nonatomic, strong)VMVideo *video;

@end

@implementation VMVideoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:self.videoImage
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.videoImage
                                      attribute:NSLayoutAttributeWidth
                                      multiplier:199.0/320.0
                                      constant:0];
    constraint.priority = 1000;
	// Do any additional setup after loading the view, typically from a nib.
    [self.videoImage.superview addConstraint:constraint];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.video) {
        [self.appDelegate.tracker sendView:[NSString stringWithFormat: @"/vimeo/video/%@", self.video.identifier]];

        VMThumbnail * thumbnail = self.video.thumbnails[2];
        XBLog(@"Image url: %@", thumbnail.url);
        [self.videoImage setImageWithURL:[NSURL URLWithString:thumbnail.url] placeholderImage:[UIImage imageNamed:@"video_placeholder.png"]
                                 success:^(UIImage *image) {
                                     self.videoImage.image = [self generateWatermarkForImage:image];
                                 }
                                 failure:^(NSError *error) {
                                     XBLog(@"Error: %@", error);
                                 }];
        [self refreshViewWithVideoData];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = touches.anyObject;

    if (touch.view == self.videoImage) {
        [self videoImageTapped];
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

    VMVideoUrl *videoUrl = Underscore.array(self.video.videoUrls).find(^BOOL(VMVideoUrl * videoUrlEntry) {
        return [videoUrlEntry.codec isEqualToString:@"hls"] && [videoUrlEntry.type isEqualToString:@"all"];
    });

    if (!videoUrl) {
        videoUrl = Underscore.array(self.video.videoUrls).find(^BOOL(VMVideoUrl * videoUrlEntry) {
            return [videoUrlEntry.codec isEqualToString:@"hls"];
        });
    }

    if (!videoUrl) {
        videoUrl = Underscore.array(self.video.videoUrls).first;
    }

    if (videoUrl) {
        NSLog(@"Video URL: %@", videoUrl.url);
        [self playMovieStream: [NSURL URLWithString: videoUrl.url]];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.title = NSLocalizedString(@"Erreur", nil);
        alertView.message = NSLocalizedString(@"Pas d'url disponible pour la video", nil);

        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            XBLog("Validated alert view");
        }];
    }
}

- (void)updateWithVideo:(VMVideo *)video {
    self.video = video;
    [self refreshViewWithVideoData];
}

-(void)refreshViewWithVideoData {
    self.title = self.video.title.length > 25 ?
            [NSString stringWithFormat: @"%@ ...", [self.video.title substringToIndex:25]] :
            self.video.title;
    self.videoImage.image = [UIImage imageNamed:@"video_placeholder.png"];

    self.displayName.text = self.video.owner.displayName;
    self.date.text = [self.video.uploadDate formatDateTime];
    self.playCount.text = [NSString stringWithFormat: @"%@", self.video.playCount];
    self.likeCount.text = [NSString stringWithFormat: @"%@", self.video.likeCount];
    self.commentCount.text = [NSString stringWithFormat: @"%@", self.video.commentCount];
    self.definition.text = [NSString stringWithFormat: @"%@", self.video.isHd ? @"HD":@""];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

/* Called soon after the Play Movie button is pressed to play the streaming movie. */
-(void)playMovieStream:(NSURL *)movieURL
{
    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
    /* If we have a streaming url then specify the movie source type. */
    if ([movieURL.pathExtension compare:@"m3u8" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        movieSourceType = MPMovieSourceTypeStreaming;
    }
    else if ([movieURL.pathExtension compare:@"mp4" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        movieSourceType = MPMovieSourceTypeFile;
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

        [player.moviePlayer prepareToPlay];

        [self presentMoviePlayerViewControllerAnimated:player];
    }

}

@end



