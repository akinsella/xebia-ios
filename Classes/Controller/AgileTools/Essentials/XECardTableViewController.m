//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XECardTableViewController.h"
#import "UIViewController+XBAdditions.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XECardCell.h"
#import "XECard.h"
#import "XECardDetailsViewController.h"
#import "XBArrayDataSource+protected.h"

@interface UITableViewController ()
-(void)initialize;
@end

@interface XECardTableViewController()
@property(nonatomic, strong) XECategory *category;
@end

@implementation XECardTableViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/cards/categories/%@", self.category.identifier];
}

- (void)viewDidLoad {

    self.delegate = self;

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.category) {
        self.title = self.category.label;
    }
    else {
        self.title = NSLocalizedString(@"Cards", nil);
    }

    self.navigationController.navigationBarHidden = NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"XECard" ;

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XECardCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XECardCell *cardCell = (XECardCell *) cell;

    XECard *card = self.dataSource[(NSUInteger) indexPath.row];
    [cardCell updateWithCard: card];
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];

    NSString * path = self.category ? [NSString stringWithFormat:@"/cards/categories/%@", self.category.identifier] : @"/cards";
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath: path];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"cards" typeClass:[XECard class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    XECard *card = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Card selected: %@", card);

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    XECardDetailsViewController *cardDetailsViewController = (XECardDetailsViewController *)[sb instantiateViewControllerWithIdentifier:@"cardDetails"];
    [cardDetailsViewController updateWithCards:self.dataSource.array andIndex:(NSUInteger) indexPath.row];
    [self.navigationController pushViewController:cardDetailsViewController animated:YES];
}

- (void)updateWithCategory:(XECategory *)category {
    self.category = category;
    [self initialize];
}

@end