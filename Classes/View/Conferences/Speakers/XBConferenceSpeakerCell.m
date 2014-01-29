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
#import "NSString+XBAdditions.h"

@implementation XBConferenceSpeakerCell

- (void)awakeFromNib {
    self.photoImageView.backgroundColor = [UIColor grayColor];
    self.photoImageView.layer.cornerRadius = CGRectGetWidth(self.photoImageView.frame) / 2;
    self.photoImageView.clipsToBounds = YES;
}

- (void)configureWithSpeaker:(XBConferenceSpeaker *)speaker {
    self.firstNameLabel.text = speaker.firstName;
    self.lastNameLabel.text = speaker.lastName;
    [self.photoImageView setImageWithURL:[speaker.imageURI url] placeholderImage:nil];
}

@end
