//
//  XBConferenceSpeakerCell.m
//  Xebia
//
//  Created by Simone Civetta on 26/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceSpeakerCell.h"
#import "XBConferenceSpeaker.h"
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <SDWebImage/SDWebImageManager.h>
#import "NSString+XBAdditions.h"

@interface XBConferenceSpeakerCell ()

@property (nonatomic, strong) UIImage* defaultAvatarImage;
@property (nonatomic, strong) XBConferenceSpeaker *speaker;

@end

@implementation XBConferenceSpeakerCell

- (void)configure {

    [super configure];

    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];

    self.photoImageView.offset = 2;
    self.photoImageView.backgroundColor = [UIColor clearColor];
    self.photoImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large"];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    XBLog("Default - %@", self.photoImageView.image);
    self.photoImageView.offset = 2;
    self.photoImageView.backgroundColor = [UIColor clearColor];
    self.photoImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large"];
    self.photoImageView.defaultImage = self.defaultAvatarImage;
}

- (void)configureWithSpeaker:(XBConferenceSpeaker *)speaker {

    self.speaker = speaker;

    self.firstNameLabel.text = speaker.firstName;
    self.lastNameLabel.text = speaker.lastName;

    self.photoImageView.image = self.defaultAvatarImage;
    [[SDWebImageManager sharedManager] downloadImageWithURL:speaker.imageURL.url
                                               options:(SDWebImageOptions) kNilOptions
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                 if ((error || !image) && self.speaker == speaker) {
                                                     XBLog("Error - %@ for: %@ %@", error, speaker.firstName, speaker.lastName);
                                                     self.photoImageView.image = self.defaultAvatarImage;
                                                 }
                                                 else if (self.speaker == speaker) {
                                                     XBLog("Success - %@ for: %@ %@", image, speaker.firstName, speaker.lastName);
                                                     self.photoImageView.image = image;
                                                 }
                                             }];
}

@end
