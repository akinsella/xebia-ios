//
// Created by Alexis Kinsella on 22/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "WPAbstractPostContentStructuredElementCell.h"

@interface WPPostContentImageElementCell : WPAbstractPostContentStructuredElementCell
        //<UIGestureRecognizerDelegate>

@property (nonatomic, weak)id<WPPostContentElementCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) NSMutableDictionary *heightImageCache;

@end