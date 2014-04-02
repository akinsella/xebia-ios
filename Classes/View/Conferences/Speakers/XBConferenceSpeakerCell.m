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

@implementation XBConferenceSpeakerCell

- (void)awakeFromNib {
    self.photoImageView.offset = 2;
    self.photoImageView.backgroundColor = [UIColor clearColor];
    self.photoImageView.backgroundImage = [UIImage imageNamed:@"dp_holder_large"];
}

- (void)configureWithSpeaker:(XBConferenceSpeaker *)speaker {
    self.firstNameLabel.text = speaker.firstName;
    self.lastNameLabel.text = speaker.lastName;
    
    self.photoImageView.image = nil;
    [[SDWebImageManager sharedManager] downloadWithURL:[speaker.imageURL url]
                                               options:kNilOptions
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (error || !image) {
                                                     self.photoImageView.image = nil;
                                                 }
                                                 else {
                                                     self.photoImageView.image = image;
                                                 }
                                             }];
}

@end
