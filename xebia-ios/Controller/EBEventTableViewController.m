//
//  EBEventTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/UI.h>
#import "EBEventTableViewController.h"
#import "EBEvent.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "EBEventCell.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+XBAdditions.h"
#import "XBMainViewController.h"

@interface EBEventTableViewController ()
@property (nonatomic, strong) RKTableController *tableController;
@property (nonatomic, strong) UIImage*defaultImage;
@end

@implementation EBEventTableViewController




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Owners";
    self.defaultImage = [UIImage imageNamed:@"eventbrite"];

    [super viewDidLoad];
}

- (int)maxDataAgeInSecondsBeforeServerFetch {
    return 120;
}

- (Class)dataClass {
    return [EBEvent class];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"EBEvent";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"EBEventCell";
}

- (NSString *)urlPath {
    return @"/api/eventbrite/events";
}

- (NSArray *)fetchDataFromDB {
    return [EBEvent MR_findAllSortedBy:@"start_date" ascending:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    EBEventCell *eventCell = (EBEventCell *) cell;
    [eventCell configure];

    EBEvent *event = [self.delegate objectAtIndex:(NSUInteger) indexPath.row];
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