//
// Created by Alexis Kinsella on 21/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//

#import "EBEvent.h"
#import "XBViewController.h"

@interface EBEventDetailsViewController : XBViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeEndLabel;
@property (weak, nonatomic) IBOutlet UITextView *excerptTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong)EBEvent *event;

- (void)updateWithEvent:(EBEvent *)event;

- (IBAction)openEventInWebView;

@end