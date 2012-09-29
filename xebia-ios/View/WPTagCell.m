//
//  WPTagCell.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPTagCell.h"

@implementation WPTagCell

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize bottomDetailLabel;
@synthesize itemCount = _itemCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setItemCount:(NSInteger)itemCount {
    _itemCount = itemCount;
    [self updateBottomDetailLabel];
}


- (void)updateBottomDetailLabel {
    self.bottomDetailLabel.text = [NSString stringWithFormat: 
                                   self.itemCount > 1 ? @"%d posts" : @"%d post", 
                                   self.itemCount];
}

@end
