//
// Created by Alexis Kinsella on 02/12/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <MJPopupViewController/UIViewController+MJPopupViewController.h>
#import "EBEventMapViewController.h"
#import "EBEvent.h"
#import "UIViewController+XBAdditions.h"

@interface EBEventMapViewController()

@property(nonatomic, strong)EBEvent *event;

@end

@implementation EBEventMapViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/events/%@", self.event.identifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.title = self.event.title;
    self.navigationController.navigationBarHidden = NO;
}

-(void)updateWithEvent:(EBEvent *)event {
    self.event = event;

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;

    region.span = span;
    region.center = CLLocationCoordinate2DMake([self.event.venue.latitude doubleValue], [self.event.venue.longitude doubleValue]);
    [self.mapView setRegion:region animated:YES];
}

-(IBAction)closePopup {
    EBEventMapViewController *eventMapViewController = (EBEventMapViewController *)[self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"eventMap"];
    [eventMapViewController updateWithEvent: self.event];
    [self.appDelegate.mainViewController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopBottom];
}


@end