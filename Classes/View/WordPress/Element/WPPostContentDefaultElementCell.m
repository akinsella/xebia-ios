//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WPPostContentDefaultElementCell.h"

@implementation WPPostContentDefaultElementCell

- (void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    [super updateWithWPPostContentElement:element];

    self.typeLabel = self.element.type;
}

- (CGFloat)heightForCell:(UITableView *)tableView {
    return self.imageView.image.size.height + 2 * 10;
}

@end