//
//  XBConferenceTrackCell.m
//  Xebia
//
//  Created by Simone Civetta on 09/02/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceTrackCell.h"
#import "XBConferenceTrack.h"
#import "DTAttributedTextContentView.h"
#import "NSAttributedString+HTML.h"

@implementation XBConferenceTrackCell

- (void)configureWithTrack:(XBConferenceTrack *)track {
    self.nameLabel.text = track.name;
    NSData *data = [[NSString stringWithFormat:@"%@%@%@", @"<font face='HelveticaNeue'>", track.description, @"</font>"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{DTUseiOS6Attributes: @(YES)};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    self.descriptionLabel.attributedString = attributedString;
    [self.descriptionLabel sizeToFit];
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    NSLog(@"%@", NSStringFromCGSize(self.descriptionLabel.intrinsicContentSize));
    return 11 + self.nameLabel.intrinsicContentSize.height + 8 + self.descriptionLabel.intrinsicContentSize.height + 8;
}

@end
