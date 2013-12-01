//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBEventDetailsViewController.h"
#import "NSDate+XBAdditions.h"
#import "UIViewController+XBAdditions.h"

@implementation EBEventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.event.title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
}

- (void)updateWithEvent:(EBEvent *)event {
    self.event = event;
    self.dateStartLabel.text = [event.startDate formatDayLongMonth];
    self.timeStartLabel.text = [event.startDate formatTime];
    self.dateEndLabel.text = [event.endDate formatDayLongMonth];
    self.timeEndLabel.text = [event.endDate formatTime];
    self.excerptTextView.text = event.descriptionPlainText.length < 300 ? event.descriptionPlainText : [event.descriptionPlainText substringToIndex:300];
    self.titleLabel.text = event.title;
}

-(IBAction)openEventInWebView {
    [self.appDelegate.mainViewController openURL:[NSURL URLWithString:self.event.url] withTitle:self.event.title];
}

@end