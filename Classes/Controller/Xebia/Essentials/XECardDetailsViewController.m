//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Underscore.m/Underscore.h>
#import "XECardDetailsViewController.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"
#import "XECategory.h"
#import "UIColor+XBAdditions.h"
#import "XECardDetailsQRCodePageViewController.h"
#import "XECardDetailsDescriptionPageViewController.h"

#define kNumberOfPages 2

@interface XECardDetailsViewController ()
@property(nonatomic, strong)XECard *card;
@property(nonatomic, assign)BOOL pageControlUsed;
@property(nonatomic, strong)NSArray * pageViewControllers;
@end

@implementation XECardDetailsViewController


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
    }

    return self;
}

- (void)configure {
    self.pageViewControllers = @[
            [[XECardDetailsDescriptionPageViewController alloc] init],
            [[XECardDetailsQRCodePageViewController alloc] init]
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    Underscore.arrayEach(self.pageViewControllers, ^(XECardDetailsPageViewController * pageViewController) {
        [self.scrollView addSubview:pageViewController.view];
    });

    self.titleLabel.backgroundColor = [UIColor clearColor];

    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * kNumberOfPages, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.bounces = NO;
    self.pageControl.numberOfPages = kNumberOfPages;
    self.pageControl.currentPage = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.card) {
        [self.appDelegate.tracker sendView:[NSString stringWithFormat: @"/essentials/category/%@", self.card.identifier]];
        self.title = self.card.category.label;


        self.titleBackgroundView.backgroundColor = [UIColor colorWithHex:self.card.category.color];
        self.descriptionBackgroundView.backgroundColor = [UIColor colorWithHex:self.card.category.backgroundColor];

        self.titleLabel.text = self.card.title;


        __block int pageIndex = 0;
        Underscore.arrayEach(self.pageViewControllers, ^(XECardDetailsPageViewController * pageViewController) {
            CGRect pageFrame = self.scrollView.frame;
            pageFrame.origin.x = pageFrame.size.width * pageIndex;
            pageFrame.origin.y = 0;

            pageViewController.view.frame = pageFrame;
            pageIndex++;
        });
    }

    self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
    self.pageControl.currentPage = 0;

    Underscore.arrayEach(self.pageViewControllers, ^(XECardDetailsPageViewController * pageViewController) {
        [pageViewController viewWillAppear:animated];
    });
}

- (void)updateWithCard:(XECard *)card {
    self.card = card;

    Underscore.arrayEach(self.pageViewControllers, ^(XECardDetailsPageViewController * pageViewController) {
        [pageViewController updateWithCard:card];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (self.pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }

    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = (int)floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = self.pageControl.currentPage;

    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];

    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControlUsed = YES;
}


@end