//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "WPPostContentStructuredElement.h"
#import "WPPostContentStructuredElementCellDelegate.h"

@protocol WPPostContentElementCellDelegate

-(void) reloadCellForElement:(WPPostContentStructuredElement *)element;

@end

@interface WPAbstractPostContentStructuredElementCell : UITableViewCell <WPPostContentStructuredElementCellDelegate>

@property (nonatomic, strong, readonly)WPPostContentStructuredElement *element;

@end