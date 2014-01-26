//
//  XBConferenceSpeakerCell.m
//  Xebia
//
//  Created by Simone Civetta on 26/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceSpeakerCell.h"
#import "XBConferenceSpeaker.h"

@implementation XBConferenceSpeakerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureWithSpeaker:(XBConferenceSpeaker *)speaker {
    self.firstNameLabel.text = speaker.firstName;
    self.lastNameLabel.text = speaker.lastName;
}

@end
