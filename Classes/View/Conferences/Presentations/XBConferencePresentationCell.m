//
//  XBConferencePresentationCell.m
//  Xebia
//
//  Created by Simone Civetta on 16/02/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferencePresentationCell.h"
#import "XBConferencePresentation.h"

@implementation XBConferencePresentationCell

- (void)awakeFromNib {
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)configureWithPresentation:(XBConferencePresentation *)presentation {
    self.titleLabel.text = presentation.title;
    //TODO: Finish configuration
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 8 + self.titleLabel.intrinsicContentSize.height + 8;
}

@end
