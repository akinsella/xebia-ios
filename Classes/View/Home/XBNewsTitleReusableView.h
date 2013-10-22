//
// Created by Alexis Kinsella on 21/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface XBNewsTitleReusableView  : UICollectionReusableView

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end