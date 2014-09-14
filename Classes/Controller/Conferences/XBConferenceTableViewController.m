//
// Created by Alexis Kinsella on 11/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AFNetworking/UIImageView+AFNetworking.h>
#import "XBConferenceTableViewController.h"
#import "UIViewController+XBAdditions.h"
#import "XBConferenceCell.h"
#import "XBConference.h"
#import "XBConferenceHomeViewController.h"
#import "NSString+XBAdditions.h"
#import "XBConferenceDataSource.h"

@implementation XBConferenceTableViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/conferences"];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.title = NSLocalizedString(@"Conferences", nil);

    [self addMenuButton];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"XBConference";

    return cellReuseIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferenceCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    XBConferenceCell *conferenceCell = (XBConferenceCell *) cell;
    XBConference *conference = self.dataSource[(NSUInteger) indexPath.row];
    conferenceCell.titleLabel.text = conference.name;
    [conferenceCell.iconImageView setImageWithURL:conference.iconUrl.url];
}

- (XBArrayDataSource *)buildDataSource {
    return [XBConferenceDataSource dataSource];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBConference *conference = self.dataSource[(NSUInteger) indexPath.row];
    NSLog(@"Conference selected: %@", conference);

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    XBConferenceHomeViewController *conferenceHomeViewController = (XBConferenceHomeViewController *) [sb instantiateViewControllerWithIdentifier:@"conferenceHome"];
    [conferenceHomeViewController updateWithConference:conference];
    [self.navigationController pushViewController:conferenceHomeViewController animated:YES];
}


@end