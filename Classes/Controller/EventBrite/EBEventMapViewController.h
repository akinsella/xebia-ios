//
// Created by Alexis Kinsella on 02/12/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XBViewController.h"

@class EBEvent;

@interface EBEventMapViewController : XBViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property(nonatomic,strong) IBOutlet MKMapView *mapView;

- (void)updateWithEvent:(EBEvent *)event;

- (IBAction)closePopup;

@end