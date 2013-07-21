//
// Created by Alexis Kinsella on 21/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <DTCoreText/DTLazyImageView.h>

#import "XECard.h"
#import "DTAttributedTextView.h"
#import "XECardDetailsPageViewController.h"

@interface XECardDetailsDescriptionPageViewController : XECardDetailsPageViewController<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>

@property (strong, nonatomic) IBOutlet DTAttributedTextView *descriptionTextView;

@end