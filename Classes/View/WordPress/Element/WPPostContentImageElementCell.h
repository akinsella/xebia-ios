//
// Created by Alexis Kinsella on 22/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "WPAbstractPostContentStructuredElementCell.h"

@protocol WPPostContentImageElementCellDelegate

-(void) reloadCellForElement:(WPPostContentStructuredElement *)element;

@end

@interface WPPostContentImageElementCell : WPAbstractPostContentStructuredElementCell

@property (nonatomic, weak)id<WPPostContentImageElementCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) NSMutableDictionary *heightImageCache;

@end