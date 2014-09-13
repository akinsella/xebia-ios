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
#import <SDWebImage/SDWebImageManager.h>
#import "XBConferenceDayViewController.h"
#import "NSString+XBAdditions.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+XBAdditions.h"
#import "XBConferenceRatingTableViewController.h"
#import "XBConferenceLocationManager.h"

@interface XBConferenceHomeViewController()

@property (nonatomic, strong) XBConferenceDownloader *downloader;
@property (nonatomic, strong) XBConferenceScheduleDataSource *dayDataSource;
@property (nonatomic, strong) XBConferenceLocationManager *conferenceLocationManager;

@end

@implementation XBConferenceHomeViewController {
    CGFloat _headerViewHeight;
}

- (void)initialize {
    [super initialize];
    [self applyTheme];
}

- (void)applyTheme {
    _headerViewHeight = CGRectGetHeight(self.headerView.frame);
    self.logoImageView.backgroundColor = [UIColor grayColor];
    self.logoImageView.layer.cornerRadius = CGRectGetWidth(self.logoImageView.frame) / 2.0;
    self.logoImageView.clipsToBounds = YES;
    [self.logoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.logoImageView.layer setBorderWidth:2.0f];
}

- (void)viewDidLoad {

    self.delegate = self;

    [self addMenuButton];

    [self configureTableView];
    [self createConferenceDownloader];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createConferenceDownloader {
    self.downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    [self.downloadActivityIndicator startAnimating];

    if ([self.downloader isBundleCached]) {
        [self applyValues];

        [self.dayDataSource loadAndFilterDistinctDays:^{
            [self.tableView reloadData];
        }];
    }

    [self.downloader downloadAllResources:^(NSError *error) {
        if (error && ![self.downloader isBundleCached]) {
            [self showErrorProgressHUDWithMessage:NSLocalizedString(@"Loading error", @"Loading error") afterDelay:2.0 callback:nil];
        } else {
            [self applyValues];

            [self.dayDataSource loadAndFilterDistinctDays:^{
                [self.tableView reloadData];
            }];
        }
        
        [self.downloadActivityIndicator stopAnimating];
    }];
}

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/conferences/%@", self.conference.identifier];
}

- (void)applyValues {
    [self downloadAndApplyLogo];
    [self setupConferenceLocationMonitoring];
    self.titleLabel.text = self.conference.name;
    self.title = self.conference.name;
}

- (void)downloadAndApplyLogo
{
    self.backgroundImageView.alpha = 0.0;
    [self.logoImageView setImageWithURL:self.conference.logoUrl.url];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[self.conference.backgroundUrl url]
                                               options:(SDWebImageOptions) kNilOptions
                                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                 if (error || !image) {
                                                     self.backgroundImageView.image = nil;
                                                 }
                                                 else {
                                                     self.backgroundImageView.image = [image applyBlurWithRadius:2.0 tintColor:[UIColor colorWithHex:@"#000000" alpha:0.4] saturationDeltaFactor:1.0 maskImage:nil];
                                                     [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                                         self.backgroundImageView.alpha = 1.0;
                                                     } completion:nil];
                                                 }
                                             }];
}

- (XBArrayDataSource *)buildDataSource {

    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    NSString *path = [[downloader bundleFolderPath] stringByAppendingPathComponent:@"schedule"];
    self.dayDataSource = [XBConferenceScheduleDataSource dataSourceWithResourcePath:path];
    
    NSArray *menuItems = @[
                           @{@"title": NSLocalizedString(@"Speakers", nil)},
                           @{@"title": NSLocalizedString(@"Tracks", nil)},
                           @{@"title": NSLocalizedString(@"Rooms", nil)}
                           ];

    return [XBArrayDataSource dataSourceWithArray:@[
            @[@"Date"],
            self.dayDataSource,
            menuItems,
            @[@"Ratings"]
    ]];
}


- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DateCellIdentifier = @"XBConferenceHomeDateCell";
    static NSString *DayCellIdentifier = @"XBConferenceHomeDayCell";
    static NSString *MenuItemCellIdentifier = @"XBConferenceHomeMenuItemCell";

    NSArray *identifiers = @[DateCellIdentifier, DayCellIdentifier, MenuItemCellIdentifier, MenuItemCellIdentifier];
    return identifiers[indexPath.section];
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DateCellNibName = @"XBConferenceHomeDateCell";
    static NSString *DayCellNibName = @"XBConferenceHomeDayCell";
    static NSString *MenuItemCellNibName = @"XBConferenceHomeMenuItemCell";
    
    NSArray *identifiers = @[DateCellNibName, DayCellNibName, MenuItemCellNibName, MenuItemCellNibName];
    return identifiers[indexPath.section];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [(XBConferenceHomeDateCell *)cell configureWithConference:self.conference];
            break;

        case 1:
            [(XBConferenceHomeDayCell *) cell configureWithDay:[self.dayDataSource[indexPath.row] fromTime]];
            break;

        case 2:
            [(XBConferenceHomeMenuItemCell *) cell configureWithTitle:self.dataSource[indexPath.section][indexPath.row][@"title"]];
            break;

        case 3:
            [(XBConferenceHomeMenuItemCell *) cell configureWithTitle:NSLocalizedString(@"My ratings", @"My ratings")];
            break;

        default:break;
    }
}

- (void)onSelectCell: (UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"ShowDay" sender:nil];
    } else if (indexPath.section == 2) {
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
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"ShowRatings" sender:nil];
                break;
                
            default:break;
        }
    }

    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDay"]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        XBConferencePresentation *presentation = self.dayDataSource[selectedIndexPath.row];
        XBConferenceDayViewController *viewController = segue.destinationViewController;
        viewController.conference = self.conference;
        viewController.day = presentation.fromTime;

    } else if ([segue.identifier isEqualToString:@"ShowSpeakers"]) {
        XBConferenceSpeakerViewController *viewController = segue.destinationViewController;
        viewController.conference = self.conference;

    } else if ([segue.identifier isEqualToString:@"ShowRooms"]) {
        XBConferenceRoomViewController *viewController = segue.destinationViewController;
        viewController.conference = self.conference;

    } else if ([segue.identifier isEqualToString:@"ShowTracks"]) {
        XBConferenceTrackViewController *viewController = segue.destinationViewController;
        viewController.conference = self.conference;

    } else if ([segue.identifier isEqualToString:@"ShowRatings"]) {
        XBConferenceRatingTableViewController *viewController = segue.destinationViewController;
        viewController.conference = self.conference;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20.0)];
    header.backgroundColor = [UIColor colorWithHex:@"#E0E0E0"];
    return header;
}

#pragma mark - Header effects
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.backgroundImageView.frame = ({
        CGRect frame = self.backgroundImageView.frame;
        frame.origin.y = scrollView.contentOffset.y;
        frame.size.height = _headerViewHeight - scrollView.contentOffset.y;
        frame;
    });
}

- (void)setupConferenceLocationMonitoring {
    // TODO: add beacons to manager
}

@end