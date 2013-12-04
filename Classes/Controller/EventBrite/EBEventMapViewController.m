//
// Created by Alexis Kinsella on 02/12/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "EBEventMapViewController.h"
#import "EBEvent.h"
#import "UIViewController+XBAdditions.h"

@interface EBEventMapViewController()

@property(nonatomic, strong)EBEvent *event;

@end

@implementation EBEventMapViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/events/%@/map", self.event.identifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.closeButton.title = NSLocalizedString(@"Close", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateMap];

    self.title = NSLocalizedString(@"Map", nil);
    self.navigationController.navigationBarHidden = NO;
}

-(void)updateWithEvent:(EBEvent *)event {
    self.event = event;
}

- (void)updateMap {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;

    region.span = span;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.event.venue.latitude doubleValue], [self.event.venue.longitude doubleValue]);

    region.center = CLLocationCoordinate2DMake([self.event.venue.latitude doubleValue], [self.event.venue.longitude doubleValue]);
    [self.mapView setRegion:region animated:YES];

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    [annotation setTitle:self.event.venue.address];
    [annotation setSubtitle:[NSString stringWithFormat:@"%@, %@ (%@)", self.event.venue.postalCode, self.event.venue.city, self.event.venue.country]];
    [self.mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self updateMap];
}

-(IBAction)closePopup {
    EBEventMapViewController *eventMapViewController = (EBEventMapViewController *)[self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"eventMap"];
    [eventMapViewController updateWithEvent: self.event];
    [self.appDelegate.mainViewController dismissViewControllerAnimated: YES  completion:^{}];
}

@end