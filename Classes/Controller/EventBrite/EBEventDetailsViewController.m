//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "EBEventDetailsViewController.h"
#import "EBEvent.h"
#import "EBEventDetailsInformationPageViewController.h"
#import "EBEventDetailsMapPageViewController.h"

@interface EBEventDetailsViewController()

@property NSArray *eventViewControllers;

@end

@implementation EBEventDetailsViewController

- (instancetype)initWithEvent:(EBEvent *)event {
    self = [super init];
    if (self) {
        self.
        self.event = event;
        self.dataSource = self;
        self.eventViewControllers = @[
                [[EBEventDetailsInformationPageViewController alloc] initWithEvent:event],
                [[EBEventDetailsMapPageViewController alloc] initWithEvent:event]
        ];
        [self setViewControllers:self.eventViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }

    return self;
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