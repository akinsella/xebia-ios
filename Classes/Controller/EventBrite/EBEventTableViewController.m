//
//  EBEventTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "EBEventTableViewController.h"
#import "EBEvent.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "EBEventCell.h"
#import "UIViewController+XBAdditions.h"
#import "XBPListConfigurationProvider.h"
#import "GAITracker.h"

@interface EBEventTableViewController ()
@property (nonatomic, strong) UIImage*defaultImage;
@end

@implementation EBEventTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/eventbrite/event"];

    self.delegate = self;
    self.title = @"Events";
    self.defaultImage = [UIImage imageNamed:@"eventbrite"];

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

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/eventbrite/event"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[EBEvent class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    EBEventCell *eventCell = (EBEventCell *) cell;
    [eventCell configure];

    EBEvent *event = self.dataSource[(NSUInteger) indexPath.row];
    [eventCell.imageView setImage: self.defaultImage];
    eventCell.descriptionLabel.delegate = self;
    eventCell.identifier = event.identifier;
    eventCell.titleLabel.text = event.title;

    NSString *description = event.description_plain_text;

    description = [description stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];

    if ([event.description_plain_text length] > 128) {
        description = [NSString stringWithFormat:@"%@ ...",  [description substringToIndex:128]];
    }

    eventCell.descriptionLabel.text = description;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Url requested: %@", url);
    [self.appDelegate.mainViewController openURL:url withTitle:@"EventBrite"];
}

@end