//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECardTableViewController.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XECardCell.h"
#import "XEDeck.h"
#import "XECard.h"
#import "XECardFront.h"
#import "XECardBack.h"
#import "XECardDetailsViewController.h"

@implementation XECardTableViewController


- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/xebia/essentials/card"];

    self.delegate = self;
    self.title = NSLocalizedString(@"Cards", nil);

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"XECard" ;

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"XECardCell";
}


- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XECardCell *cardCell = (XECardCell *) cell;

    XECard *card = self.dataSource[(NSUInteger) indexPath.row];
    cardCell.titleLabel.text = card.front.para;
    cardCell.descriptionLabel.text = card.back.para;
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/card"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"cards" typeClass:[XECard class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    XECard *card = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Card selected: %@", card);

    XECardDetailsViewController *cardDetailsViewController = (XECardDetailsViewController *) [[self appDelegate].viewControllerManager getOrCreateControllerWithIdentifier:@"cardDetails"];
    cardDetailsViewController.card = card;
    [self.navigationController pushViewController:cardDetailsViewController animated:YES];
}

@end