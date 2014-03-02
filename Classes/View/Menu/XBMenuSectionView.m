//
// Created by Simone Civetta on 02/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBMenuSectionView.h"


@implementation XBMenuSectionView {

}

+ (instancetype)sectionViewWithTitle:(NSString *)title
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil];

    XBMenuSectionView *view = nibViews[0];
    [view configureWithTitle:title];
    return view;
}

- (void)configureWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end