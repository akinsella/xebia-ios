//
// Created by Simone Civetta on 10/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceHomeViewController.h"
#import "XBConferenceHomeDateCell.h"
#import "XBConferenceHomeDayCell.h"
#import "XBConferenceHomeMenuItemCell.h"


@implementation XBConferenceHomeViewController {

}
- (void)initialize {
    [super initialize];
}

- (void)viewDidLoad
{
    self.delegate = self;
    [self configureTableView];
    [super viewDidLoad];
}

- (NSString *)trackPath {
    return @"/conferenceHome";
}

- (XBArrayDataSource *)buildDataSource {
    NSArray *date = @[@{@"title": NSLocalizedString(@"Day 1", nil)}];

    NSArray *days = @[
            @{@"title": NSLocalizedString(@"Day 1", nil)},
            @{@"title": NSLocalizedString(@"Day 2", nil)},
            @{@"title": NSLocalizedString(@"Day 3", nil)}
    ];

    NSArray *menuItems = @[
            @{@"title": NSLocalizedString(@"Speakers", nil)},
            @{@"title": NSLocalizedString(@"Sessions", nil)},
            @{@"title": NSLocalizedString(@"Rooms", nil)},
            @{@"title": NSLocalizedString(@"Tracks", nil)}
    ];

    return [XBArrayDataSource dataSourceWithArray:@[date, days, menuItems]];
}


- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DateCellIdentifier = @"XBConferenceHomeDateCell";
    static NSString *DayCellIdentifier = @"XBConferenceHomeDayCell";
    static NSString *MenuItemCellIdentifier = @"XBConferenceHomeMenuItemCell";

    NSArray *identifiers = @[DateCellIdentifier, DayCellIdentifier, MenuItemCellIdentifier];
    return identifiers[indexPath.section];
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DateCellNibName = @"XBConferenceHomeDateCell";
    static NSString *DayCellNibName = @"XBConferenceHomeDayCell";
    static NSString *MenuItemCellNibName = @"XBConferenceHomeMenuItemCell";
    
    NSArray *identifiers = @[DateCellNibName, DayCellNibName, MenuItemCellNibName];
    return identifiers[indexPath.section];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [(XBConferenceHomeDateCell *)cell configureWithConference:nil];
            break;

        case 1:
            [(XBConferenceHomeDayCell *) cell configureWithTitle:self.dataSource[indexPath.section][indexPath.row][@"title"]];
            break;

        case 2:
            [(XBConferenceHomeMenuItemCell *) cell configureWithTitle:self.dataSource[indexPath.section][indexPath.row][@"title"]];
            break;
        default:break;
    }
}

- (void)onSelectCell: (UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end