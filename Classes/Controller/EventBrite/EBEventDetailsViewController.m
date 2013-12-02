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
#import "UIViewController+MJPopupViewController.h"

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
    self.attendingLabel.titleLabel.text = [NSString stringWithFormat:@"%@%@",
        NSLocalizedString(@"I attend the meetup", nil),
        [event.capacity intValue] > 0 ? [NSString stringWithFormat: @" (%@)", NSLocalizedString(@"places", nil)] : @""

    ];

    NSString *mapImageURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@,%@&zoom=13&size=640x256&maptype=roadmap&markers=color:red%%7Clabel:S%%7C%@,%@&sensor=false",
            self.event.venue.address,
            self.event.venue.postalCode,
            self.event.venue.city,
            self.event.venue.latitude,
            self.event.venue.longitude
    ];

    [self.mapButton.imageView  setImageWithURL:[NSURL URLWithString:mapImageURL]
                              placeholderImage: self.placeholderImage
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                         if (error || !image) {
                                             XBLog(@"Error: %@", error);
                                         }
                                     }];

}

-(IBAction)openEventDetailsInWebView {
    [self.appDelegate.mainViewController openURL:[NSURL URLWithString:self.event.url] withTitle:self.event.title];
}

-(IBAction)openEventMapInWebView {
    EBEventMapViewController *eventMapViewController = (EBEventMapViewController *)[self.appDelegate.viewControllerManager getOrCreateControllerWithIdentifier:@"eventMap"];
    [eventMapViewController updateWithEvent: self.event];
    [self.appDelegate.mainViewController presentPopupViewController:eventMapViewController
                                                      animationType:MJPopupViewAnimationSlideBottomTop];
}

@end