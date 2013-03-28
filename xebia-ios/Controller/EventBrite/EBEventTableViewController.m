//
//  EBEventTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "EBEventTableViewController.h"
#import "EBEvent.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "EBEventCell.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"
#import "JSONKit.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBHttpArrayDataSourceConfiguration.h"

@interface EBEventTableViewController ()
@property (nonatomic, strong) UIImage*defaultImage;
@end

@implementation EBEventTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Events";
    self.defaultImage = [UIImage imageNamed:@"eventbrite"];

    [self addRevealGesture];
    [self addMenuButton];

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"EBEvent";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"EBEventCell";
}

- (XBHttpArrayDataSourceConfiguration *)configuration {

    XBHttpArrayDataSourceConfiguration* configuration = [XBHttpArrayDataSourceConfiguration configuration];
    configuration.resourcePath = @"/api/eventbrite/events";
    configuration.storageFileName = @"eb-events.json";
    configuration.maxDataAgeInSecondsBeforeServerFetch = 120;
    configuration.typeClass = [EBEvent class];
    configuration.dateFormat = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    return configuration;
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    EBEventCell *eventCell = (EBEventCell *) cell;
    [eventCell configure];

    EBEvent *event = self.dataSource[indexPath.row];
    [eventCell.imageView setImage: self.defaultImage];
    eventCell.descriptionLabel.delegate = self;
    eventCell.identifier = event.identifier;
    eventCell.titleLabel.text = event.title;
    eventCell.descriptionLabel.text = event.description_plain_text;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"EventBrite"];
}

@end