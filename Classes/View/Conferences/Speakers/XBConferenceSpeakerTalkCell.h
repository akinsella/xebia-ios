//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBTableViewCell.h"

@class XBConferenceSpeakerTalk;

@interface XBConferenceSpeakerTalkCell : XBTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
- (void)configureWithTalk:(XBConferenceSpeakerTalk *)talk;

@end