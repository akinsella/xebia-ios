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

- (NSString *)storageFileName {
    return @"eb-events.json";
}

- (NSString *)cellNibName {
    return @"EBEventCell";
}

- (NSString *)resourcePath {
    return @"/api/eventbrite/events";
}

//- (NSDictionary *)fetchDataFromDB {
////    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
////    return [[self dataClass] MR_findAllSortedBy:@"start_date" ascending:YES inContext:localContext];
//
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent: self.storageFileName];
//    NSLog(@"Event Json path: %@", filePath);
//
//    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSDictionary *json = [fileContent objectFromJSONString];
//
//    return json;
//}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    EBEventCell *eventCell = (EBEventCell *) cell;
    [eventCell configure];

    EBEvent *event = [self objectAtIndex:(NSUInteger) indexPath.row];
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