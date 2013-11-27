//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBEventDetailsViewController.h"
#import "UIViewController+XBAdditions.h"

@interface EBEventDetailsViewController ()
@property(nonatomic, assign) NSUInteger initialIndex;
@property(nonatomic, assign)BOOL pageControlUsed;
@property(nonatomic, strong)NSArray *pageViewControllers;
@property(nonatomic, strong)UIView *containerView;
@end

@implementation EBEventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.event.title;

    self.pageViewControllers = @[
            [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"eventDetailsInfoPage"],
            [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"eventDetailsMapPage"]
    ];


    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.bounces = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sv]|"
                                                    options:kNilOptions
                                                    metrics:nil
                                                      views:@{@"sv":self.scrollView}]];
    [self.view addConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sv]|"
                                                    options:kNilOptions
                                                    metrics:nil
                                                      views:@{@"sv":self.scrollView}]];

    self.pageControl.numberOfPages = self.pageViewControllers.count;
    self.pageControl.currentPage = (NSInteger) self.initialIndex;

    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.scrollView.frame.size.width * self.pageViewControllers.count, self.scrollView.frame.size.height)];
    [self.scrollView addSubview:self.containerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageViewControllers.count, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * self.initialIndex, 0.0);

    self.containerView.frame = CGRectMake(0.0, 0.0, self.scrollView.frame.size.width * self.pageViewControllers.count, self.scrollView.frame.size.height);

    [self.view layoutSubviews];
}

- (void)updateWithEvent:(EBEvent *)event {
    self.event = event;
    self.initialIndex = (NSUInteger) index;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (self.pageControlUsed) {
        return;
    }

    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSUInteger page = (NSUInteger) (floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    NSUInteger page = (NSUInteger) self.pageControl.currentPage;

    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];

    self.pageControlUsed = YES;
}

@end