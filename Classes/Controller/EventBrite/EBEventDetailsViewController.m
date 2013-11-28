//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBEventDetailsViewController.h"

@implementation EBEventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.event.title;
    self.scrollView.frame = CGRectMake(0, 0,
            self.view.frame.size.width,
            self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height
    );
    self.scrollView.contentSize = self.innerView.frame.size;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;

    self.scrollView.frame = CGRectMake(0, 0,
            self.view.frame.size.width,
            self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height
    );
    self.scrollView.contentSize = self.innerView.frame.size;
}

- (void)updateWithEvent:(EBEvent *)event {
    self.event = event;
}

@end