//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "EBEventDetailsViewController.h"
#import "NSDate+XBAdditions.h"
#import "UIViewController+XBAdditions.h"
#import "EBEventMapViewController.h"
#import "UIImageView+XBAdditions.h"
#import "UIImage+XBAdditions.h"
#import "XBConstants.h"


#define kGoogleMapsApiKey @"AIzaSyCeZZqN7-vVmAehdjAtfRbZyw2BmsWgUu4"

@interface EBEventDetailsViewController()

@property(nonatomic,strong)UIImage *placeholderImage;

@end

@implementation EBEventDetailsViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/events/%@", self.event.identifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.innerViewWidthConstraint.constant = self.view.frame.size.width;

    NSLayoutConstraint *outputLogoViewConstraint = [NSLayoutConstraint
            constraintWithItem:self.outerLogoView
                     attribute:NSLayoutAttributeHeight
                     relatedBy:NSLayoutRelationEqual
                        toItem:self.outerLogoView
                     attribute:NSLayoutAttributeWidth
                    multiplier:160.0/320.0
                      constant:0];
    outputLogoViewConstraint.priority = 1000;
    // Do any additional setup after loading the view, typically from a nib.
    [self.outerLogoView.superview addConstraint:outputLogoViewConstraint];

    NSLayoutConstraint *mapButtonConstraint = [NSLayoutConstraint
            constraintWithItem:self.mapButton
                     attribute:NSLayoutAttributeHeight
                     relatedBy:NSLayoutRelationEqual
                        toItem:self.mapButton
                     attribute:NSLayoutAttributeWidth
                    multiplier:128.0/320.0
                      constant:0];
    mapButtonConstraint.priority = 1000;
    // Do any additional setup after loading the view, typically from a nib.
    [self.mapButton.superview addConstraint:mapButtonConstraint];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.title = self.event.title;
    self.navigationController.navigationBarHidden = NO;

    [self updateView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)updateWithEvent:(EBEvent *)event {
    self.event = event;
}

- (void)updateView {
    self.dateStartLabel.text = [self.event.startDate formatDayLongMonth];
    self.timeStartLabel.text = [self.event.startDate formatTime];
    self.dateEndLabel.text = [self.event.endDate formatDayLongMonth];
    self.timeEndLabel.text = [self.event.endDate formatTime];
    self.excerptTextView.text = self.event.descriptionPlainText.length < 300 ? self.event.descriptionPlainText : [self.event.descriptionPlainText substringToIndex:300];
    self.titleLabel.text = self.event.title;
    self.organizerLabel.text = self.event.organizer.name;
    self.addressLabel.text = self.event.venue.address;
    self.address2Label.text = self.event.venue.address2;
    self.cityLabel.text = [NSString stringWithFormat:@"%@, %@ (%@)", self.event.venue.postalCode, self.event.venue.city, self.event.venue.country ];

    NSString *attendingLabelTitle = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"I attend the meetup", nil), [self.event.capacity intValue] > 0 ? [NSString stringWithFormat: @" (%@)", NSLocalizedString(@"places", nil)] : @""];
    [self.attendingLabel setTitle:attendingLabelTitle forState:UIControlStateNormal];

    NSString *mapImageURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@,%@&zoom=13&size=%@&maptype=roadmap&markers=color:red%%7Clabel:S%%7C%@,%@&sensor=false&key=%@",
                                                       [self.self.event.venue.address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                       [self.event.venue.postalCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                       [self.event.venue.city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                       [UIScreen mainScreen].scale == 1.0 && !IS_IPAD ? @"320x128" : @"640x256",
                                                       self.event.venue.latitude,
                                                       self.event.venue.longitude,
                                                       kGoogleMapsApiKey
    ];


    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:mapImageURL]
                                               options:kNilOptions
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (error || !image) {
                                                     XBLog("Error - %@", error);
                                                     [self.mapButton setImage:self.placeholderImage forState:UIControlStateNormal];
                                                 }
                                                 else {
                                                     XBLog("Success - %@", image);
                                                     CGFloat screenScale = [UIScreen mainScreen].scale;
                                                     if (screenScale != image.scale) {
                                                         image = [UIImage imageWithCGImage:image.CGImage scale:screenScale orientation:image.imageOrientation];
                                                     }
                                                     if (IS_IPAD) {
                                                         image = [image imageScaledToSize:self.mapButton.frame.size];
                                                     }
                                                     [self.mapButton setImage:image forState:UIControlStateNormal];
                                                 }
                                             }];


}

-(IBAction)openEventDetailsInWebView {
    [self.appDelegate.mainViewController openURL:[NSURL URLWithString:self.event.url] withTitle:self.event.title];
}

-(IBAction)openEventMapInWebView {
    EBEventMapViewController *eventMapViewController = (EBEventMapViewController *)[self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"eventMap"];
    [eventMapViewController updateWithEvent: self.event];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:eventMapViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:^{}];
}

@end