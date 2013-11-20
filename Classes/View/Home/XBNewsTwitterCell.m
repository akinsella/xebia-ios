//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Underscore.m/Underscore.h>
#import "XBNewsTwitterCell.h"
#import "XBNewsMetadata.h"

@implementation XBNewsTwitterCell

- (CGFloat)heightForCell:(UITableView *)tableView {
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
    CGFloat height = 70 - 39 + size.height;

    height = MAX(70, height);

    return height;
}

- (void)updateWithNews:(XBNews *)news {
    [super updateWithNews:news];
    [self.titleLabel sizeToFit];
}

- (void)onSelection {
    [super onSelection];
    
    XBNewsMetadata *foundNewsMetadata = Underscore.array(self.news.metadata).find(^BOOL(XBNewsMetadata *newsMetadata) {
        return [newsMetadata.key isEqualToString:@"screenName"];
    });

    NSString *screenName = foundNewsMetadata ? foundNewsMetadata.value : @"<UNKNOWN>";
    NSURL * url  = [NSURL URLWithString:[NSString stringWithFormat: @"xebia://tweets/%@?screenName=%@", self.news.typeId, screenName]];
    [[UIApplication sharedApplication] openURL: url];
}

@end