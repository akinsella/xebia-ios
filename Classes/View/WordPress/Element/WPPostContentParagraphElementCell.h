//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "WPPostContentStructuredElement.h"
#import "WPAbstractPostContentStructuredElementCell.h"
#import "WPPostContentStructuredElementCellDelegate.h"
#import "DTAttributedTextCell.h"

@interface WPPostContentParagraphElementCell : DTAttributedTextCell<WPPostContentStructuredElementCellDelegate, DTAttributedTextContentViewDelegate>

@property (nonatomic, strong, readonly)WPPostContentStructuredElement *element;

@end