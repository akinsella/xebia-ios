//
// Created by Alexis Kinsella on 28/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class VMVideo;
@class MPMoviePlayerController;

@interface VMVideoDetailsViewController : UIViewController

@property (strong) MPMoviePlayerController *moviePlayerController;
@property (strong, nonatomic) IBOutlet UIView *videoBackgroundView;
@property (strong, nonatomic) IBOutlet UILabel *playCount;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;

@property (strong, nonatomic) IBOutlet UILabel *commentCount;
@property (strong, nonatomic) IBOutlet UILabel *displayName;
@property (strong, nonatomic) IBOutlet UILabel *definition;
@property (strong, nonatomic) IBOutlet UILabel *date;

@property(nonatomic, strong)VMVideo *video;

- (void)viewWillEnterForeground;
- (void)playMovieFile:(NSURL *)movieFileURL;
- (void)playMovieStream:(NSURL *)movieFileURL;

@end


