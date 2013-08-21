//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "WPAbstractPostContentStructuredElementCell.h"

@interface WPAbstractPostContentStructuredElementCell ()

@property (nonatomic, strong) WPPostContentStructuredElement *element;

@end

@implementation WPAbstractPostContentStructuredElementCell

-(void)updateWithWPPostContentElement:(WPPostContentStructuredElement *)element {
    self.element = element;
}

-(CGFloat)heightForCell {
    return 64;
}

@end