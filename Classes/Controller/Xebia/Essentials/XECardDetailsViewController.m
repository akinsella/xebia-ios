//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XECardDetailsViewController.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"
#import "XECategory.h"
#import "XECardDetailsPageViewController.h"

@interface XECardDetailsViewController ()
@property(nonatomic, strong) NSArray *cards;
@property(nonatomic, assign) NSUInteger initialIndex;
@property(nonatomic, assign)BOOL pageControlUsed;
@property(nonatomic, strong)NSMutableArray *pageViewControllers;
@end

@implementation XECardDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.cards.count, self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.bounces = NO;

    XECard *card = self.cards[self.initialIndex];
    [self.appDelegate.tracker sendView:[NSString stringWithFormat: @"/essentials/category/%@", card.category.identifier]];
    self.title = card.category.label;

    self.pageViewControllers = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < self.cards.count ; i++) {
        [self.pageViewControllers addObject:[NSNull null]];
    }

    self.pageControl.numberOfPages = self.cards.count;
    self.pageControl.currentPage = (NSInteger) self.initialIndex;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * self.initialIndex, 0.0);

    [self loadScrollViewWithPage:self.initialIndex];
    [self loadScrollViewWithPage:self.initialIndex - 1];
    [self loadScrollViewWithPage:self.initialIndex + 1];
}


- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page < 0) {
        return;
    }
    if (page >= self.cards.count) {
        return;
    }

    // replace the placeholder if necessary
    XECardDetailsPageViewController *pageViewController = self.pageViewControllers[page];
    if (pageViewController == (id)[NSNull null])
    {
        pageViewController = [[XECardDetailsPageViewController alloc] initWithCard:self.cards[page]];
        [self.pageViewControllers replaceObjectAtIndex:page withObject:pageViewController];
    }

    // add the controller's view to the scroll view
    if (pageViewController.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        pageViewController.view.frame = frame;
        [self.scrollView addSubview:pageViewController.view];
    }
}

- (void)updateWithCards:(NSArray *)cards andIndex:(NSUInteger)index {
    self.cards = cards;
    self.initialIndex = (NSUInteger) index;
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
    NSUInteger page = (NSUInteger) (floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
    self.pageControl.currentPage = page;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

    // A possible optimization would be to unload the views+controllers which are no longer visible
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
    NSUInteger page = (NSUInteger) self.pageControl.currentPage;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];

    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControlUsed = YES;
}

@end