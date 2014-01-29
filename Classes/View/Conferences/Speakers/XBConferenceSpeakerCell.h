//
//  XBConferenceSpeakerCell.h
//  Xebia
//
//  Created by Simone Civetta on 26/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBTableViewCell.h"

@class XBConferenceSpeaker;

@interface XBConferenceSpeakerCell : XBTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

- (void)configureWithSpeaker:(XBConferenceSpeaker *)speaker;

@end
