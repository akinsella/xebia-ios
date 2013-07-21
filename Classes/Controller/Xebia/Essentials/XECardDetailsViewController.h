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

@interface XECardDetailsViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *descriptionBackgroundView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property(nonatomic, strong, readonly)XECard *card;

- (IBAction)changePage:(id)sender;

- (void)updateWithCard:(XECard *)card;

@end