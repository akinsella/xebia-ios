//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingTableViewController.h"
#import "XBConferenceRatingCell.h"
#import "XBConferenceDownloader.h"
#import "XBConferenceScheduleDataSource.h"
#import "XBArrayDataSource+protected.h"
#import "XBConference.h"
#import "NSArray+XBConferenceRatingAdditions.h"
#import "XBConferencePresentationDetailViewController.h"
#import "XBConferenceRatingManager.h"

@interface XBConferenceRatingTableViewController()
@property (nonatomic, strong) NSArray *conferencePresentations;
@end

@implementation XBConferenceRatingTableViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/ratings"];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.title = NSLocalizedString(@"My ratings", nil);

    [super viewDidLoad];

    [self filterByRatings];
}

- (void)initialize {
    [super initialize];
    [self applyTheme];
}

- (void)applyTheme {

}

- (void)viewWillAppear:(BOOL)animated
{
    [self initialize];
    [self.tableView reloadData];
}

- (void)filterByRatings {
    XBConferenceScheduleDataSource *conferenceScheduleDataSource = [XBConferenceScheduleDataSource dataSourceWithResourcePath:[self pathForLocalDataSource]];
    NSArray *ratingIdentifiers = [self.dataSource.array presentationIdentifiers];
    [conferenceScheduleDataSource loadAndFilterByIdentifiers:ratingIdentifiers callback:^{
        self.conferencePresentations = [conferenceScheduleDataSource.array mappedArrayForIdentifiers:ratingIdentifiers];
        [self.tableView reloadData];
    }];
}

- (NSString *)pathForLocalDataSource {
    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"schedule"];
}

- (XBArrayDataSource *)buildDataSource {
    return [XBArrayDataSource dataSourceWithArray:[[XBConferenceRatingManager sharedManager] ratingsForConference:self.conference]];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XBConferenceRoomCell";
    return CellIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferenceRatingCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    [(XBConferenceRatingCell *) cell configureWithRating:self.dataSource[indexPath.row] presentation:self.conferencePresentations[indexPath.row]];
}

- (void)onSelectCell:(UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    if (![self.conferencePresentations[indexPath.row] isKindOfClass:[NSNull class]]) {
        [self performSegueWithIdentifier:@"ShowPresentationDetail" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    XBConferencePresentation *presentation = self.conferencePresentations[selectedIndexPath.row];
    XBConferencePresentationDetailViewController *vc = segue.destinationViewController;
    vc.conference = self.conference;
    vc.presentationIdentifier = [presentation identifier];
}

@end