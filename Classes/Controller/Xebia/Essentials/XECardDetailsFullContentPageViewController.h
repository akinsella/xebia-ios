//
// Created by Alexis Kinsella on 22/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <DTCoreText/DTAttributedTextContentView.h>
#import <DTCoreText/DTLazyImageView.h>
#import "XECardDetailsPageViewController.h"

@class DTAttributedTextView;


@interface XECardDetailsFullContentPageViewController  : XECardDetailsPageViewController<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>

@property (strong, nonatomic) IBOutlet DTAttributedTextView *fullContentTextView;

@end