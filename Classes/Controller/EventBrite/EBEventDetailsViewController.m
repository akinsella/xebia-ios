//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "EBEventDetailsViewController.h"
#import "EBEvent.h"
#import "UIViewController+XBAdditions.h"

@interface EBEventDetailsViewController()

@property NSArray *eventViewControllers;

@end

@implementation EBEventDetailsViewController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureView];
    }

    return self;
}


- (id)initWithEvent:(EBEvent *)event {
    self = [super init];
    if (self) {
        self.
        self.event = event;
        [self configureView];
    }

    return self;
}

- (void)configureView {
    self.dataSource = self;
    self.eventViewControllers = @[
            [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"eventDetailsInfoPage"],
            [self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"eventDetailsMapPage"]
    ];
    [self setViewControllers:self.eventViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshViewWithEventData];
}


- (void)updateWithEvent:(EBEvent *)event {
    self.event = event;
    [self refreshViewWithEventData];
}

-(void)refreshViewWithEventData {
    self.title = self.event.title.length > 25 ?
            [NSString stringWithFormat: @"%@ ...", [self.event.title substringToIndex:25]] :
            self.event.title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    if (pageViewController == self.eventViewControllers.firstObject) {
        return nil;
    }

    NSUInteger index = [self.eventViewControllers indexOfObject:pageViewController];
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    if (pageViewController == self.eventViewControllers.lastObject) {
        return nil;
    }

    NSUInteger index = [self.eventViewControllers indexOfObject:pageViewController];
    index++;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return self.eventViewControllers[index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.eventViewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end