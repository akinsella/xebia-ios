//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <DTCoreText/DTLazyImageView.h>
#import <DTCoreText/DTAttributedTextContentView.h>
#import "XECard.h"
#import "DTAttributedTextView.h"
#import "XBViewController.h"

@interface XECardDetailsViewController : XBViewController<UIScrollViewDelegate>

@property(nonatomic, strong, readonly) NSArray *cards;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;

- (void)updateWithCards:(NSArray *)cards andIndex:(NSUInteger)index;

@end