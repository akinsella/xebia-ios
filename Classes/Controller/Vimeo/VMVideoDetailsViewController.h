//
// Created by Alexis Kinsella on 28/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XBViewController.h"

@class VMVideo;

@interface VMVideoDetailsViewController : XBViewController

@property (strong, nonatomic) IBOutlet UILabel *playCount;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;

@property (strong, nonatomic) IBOutlet UILabel *commentCount;
@property (strong, nonatomic) IBOutlet UILabel *displayName;
@property (strong, nonatomic) IBOutlet UILabel *definition;
@property (strong, nonatomic) IBOutlet UILabel *date;

@property(nonatomic, strong, readonly)VMVideo *video;

- (instancetype)initWithVideo:(VMVideo *)video;

- (void)updateWithVideo:(VMVideo *)video;
@end


