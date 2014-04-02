//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceSpeakerTalkCell.h"
#import "XBConferenceSpeakerTalk.h"


@implementation XBConferenceSpeakerTalkCell {

}
- (void)configureWithTalk:(XBConferenceSpeakerTalk *)talk {
    self.titleLabel.text = talk.title;
    self.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 8 + self.titleLabel.intrinsicContentSize.height + 8;
}

@end