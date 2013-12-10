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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.title = self.event.title;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.innerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.scrollView.contentSize.height);
//    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollView.contentSize.height);
//    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.scrollView.contentSize.height);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)updateWithEvent:(EBEvent *)event {
    self.event = event;
    self.dateStartLabel.text = [event.startDate formatDayLongMonth];
    self.timeStartLabel.text = [event.startDate formatTime];
    self.dateEndLabel.text = [event.endDate formatDayLongMonth];
    self.timeEndLabel.text = [event.endDate formatTime];
    self.excerptTextView.text = event.descriptionPlainText.length < 300 ? event.descriptionPlainText : [event.descriptionPlainText substringToIndex:300];
    self.titleLabel.text = event.title;
    self.organizerLabel.text = event.organizer.name;
    self.addressLabel.text = event.venue.address;
    self.address2Label.text = event.venue.address2;
    self.cityLabel.text = [NSString stringWithFormat:@"%@, %@ (%@)", event.venue.postalCode, event.venue.city, event.venue.country ];

    NSString *attendingLabelTitle = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"I attend the meetup", nil), [event.capacity intValue] > 0 ? [NSString stringWithFormat: @" (%@)", NSLocalizedString(@"places", nil)] : @""];
    [self.attendingLabel setTitle:attendingLabelTitle forState:UIControlStateNormal];

    NSString *mapImageURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@,%@&zoom=13&size=%@&maptype=roadmap&markers=color:red%%7Clabel:S%%7C%@,%@&sensor=false&key=%@",
                                                       [self.event.venue.address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                       [self.event.venue.postalCode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                       [self.event.venue.city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                       [UIScreen mainScreen].scale == 1.0 ? (IS_IPAD ? @"768x307" : @"320x128") : (IS_IPAD ? @"1536x614" : @"640x256"),
                                                       self.event.venue.latitude,
                                                       self.event.venue.longitude,
                                                       kGoogleMapsApiKey
    ];


    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:mapImageURL]
                                               options:kNilOptions
                                              progress:^(NSUInteger receivedSize, long long int expectedSize) {}
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