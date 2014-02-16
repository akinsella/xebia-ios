//
// Created by Simone Civetta on 10/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceHomeViewController.h"
#import "XBConferenceHomeDateCell.h"
#import "XBConferenceHomeDayCell.h"
#import "XBConferenceHomeMenuItemCell.h"
#import "XBConferenceDownloader.h"
#import "XBConference.h"
#import "XBConferenceSpeakerViewController.h"
#import "XBConferenceRoomViewController.h"
#import "XBConferenceScheduleDataSource.h"
#import "XBConferencePresentation.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBConferenceTrackViewController.h"
#import "UIViewController+XBAdditions.h"
#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface XBConferenceHomeViewController()

@property (nonatomic, strong) XBConferenceDownloader *downloader;
@property (nonatomic, strong) XBConference *conference;
@property (nonatomic, strong) XBConferenceScheduleDataSource *dayDataSource;

@end

@implementation XBConferenceHomeViewController

- (void)initialize {
    [super initialize];
    [self applyTheme];
}

- (void)applyTheme {
    self.logoImageView.backgroundColor = [UIColor grayColor];
    self.logoImageView.layer.cornerRadius = CGRectGetWidth(self.logoImageView.frame) / 2.0;
    self.logoImageView.clipsToBounds = YES;
}

- (void)viewDidLoad {

    //TODO: Make this dynamic
    self.conference = [XBConference conferenceWithUid:@"DEVOXX"];

    self.delegate = self;

    [self addMenuButton];

    [self configureTableView];
    [self createConferenceDownloader];
    [super viewDidLoad];
}

- (void)createConferenceDownloader {
    self.downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    [self.downloadActivityIndicator startAnimating];
    [self.downloader downloadAllResources:^(NSError *error) {
        if (!error) {
            //TODO: Manage error
        }
        [self applyValues];
        
        [self.dayDataSource loadAndFilterDistinctDays:^{
            [self.tableView reloadData];
        }];
        
        [self.downloadActivityIndicator stopAnimating];
    }];
}

- (NSString *)trackPath {
    return @"/conferenceHome";
}

- (void)applyValues {
    [self.logoImageView setImageWithURL:[NSURL URLWithString:@"http://devoxx-gaelyk.appspot.com/images/LogoDevoxxBig.jpg"] placeholderImage:nil];
    self.titleLabel.text = @"DevoXX";
}

- (XBArrayDataSource *)buildDataSource {
    NSArray *date = @[@{@"title": NSLocalizedString(@"Day 1", nil)}];

    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    NSString *path = [[downloader bundleFolderPath] stringByAppendingPathComponent:@"schedule"];
    self.dayDataSource = [XBConferenceScheduleDataSource dataSourceWithResourcePath:path];
    
    NSArray *menuItems = @[
                           @{@"title": NSLocalizedString(@"Speakers", nil)},
                           @{@"title": NSLocalizedString(@"Tracks", nil)},
                           @{@"title": NSLocalizedString(@"Rooms", nil)}
                           ];

    return [XBArrayDataSource dataSourceWithArray:@[date, self.dayDataSource, menuItems]];
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
            [(XBConferenceHomeDayCell *) cell configureWithPresentation:self.dataSource[indexPath.section][indexPath.row]];
            break;

        case 2:
            [(XBConferenceHomeMenuItemCell *) cell configureWithTitle:self.dataSource[indexPath.section][indexPath.row][@"title"]];
            break;
        default:break;
    }
}

- (void)onSelectCell: (UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"ShowSpeakers" sender:nil];
                break;

            case 1:
                [self performSegueWithIdentifier:@"ShowTracks" sender:nil];
                break;

            case 2:
                [self performSegueWithIdentifier:@"ShowRooms" sender:nil];
                break;
                
            default:break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowSpeakers"]) {
        XBConferenceSpeakerViewController *viewController = segue.destinationViewController;
        viewController.conference = self.conference;
    } else if ([segue.identifier isEqualToString:@"ShowRooms"]) {
        XBConferenceRoomViewController *viewController = segue.destinationViewController;
        viewController.conference = self.conference;
    } else if ([segue.identifier isEqualToString:@"ShowTracks"]) {
        XBConferenceTrackViewController *viewController = segue.destinationViewController;
        viewController.conference = self.conference;
    }
}

@end