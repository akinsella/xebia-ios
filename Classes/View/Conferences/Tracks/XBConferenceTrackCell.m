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
#import "UIColor+XBConferenceAdditions.h"

@interface XBConferenceTrackCell()

@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation XBConferenceTrackCell

- (void)awakeFromNib {
    if (!self.colorLayer) {
        CALayer *colorLayer = [[CALayer alloc] init];
        colorLayer.frame = CGRectMake(0, 0, 6, 6);
        [self.layer addSublayer:colorLayer];
        self.colorLayer = colorLayer;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.colorLayer.frame = CGRectMake(0, 0, 6, CGRectGetHeight(self.frame) + 1);
}

- (void)configureWithTrack:(XBConferenceTrack *)track {
    self.nameLabel.text = track.name;
    NSData *data = [[NSString stringWithFormat:@"%@%@%@", @"<font face='HelveticaNeue'>", track.description, @"</font>"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{DTUseiOS6Attributes: @(YES)};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    self.descriptionLabel.attributedString = attributedString;
    [self.descriptionLabel sizeToFit];
    self.colorLayer.backgroundColor = [UIColor colorWithTrackIdentifier:track.name].CGColor;
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return 11 + self.nameLabel.intrinsicContentSize.height + 8 + self.descriptionLabel.intrinsicContentSize.height + 8;
}

@end
