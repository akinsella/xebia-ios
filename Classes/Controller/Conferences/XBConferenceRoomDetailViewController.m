//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRoomDetailViewController.h"
#import "XBConferenceTrack.h"
#import "DTAttributedTextContentView.h"
#import "NSAttributedString+HTML.h"
#import "XBConferenceTrackDetailDataSource.h"
#import "XBConferenceDownloader.h"
#import "XBConference.h"
#import "XBConferencePresentation.h"
#import "XBConferencePresentationCell.h"
#import "XBConferenceRoom.h"
#import "XBConferenceRoomDetailDataSource.h"
#import "XBConferencePresentationDetailViewController.h"


@implementation XBConferenceRoomDetailViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/detail"];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.title = NSLocalizedString(@"Tracks", nil);

    [super viewDidLoad];
}

- (void)initialize {
    [super initialize];
    [self applyTheme];
}

- (void)applyTheme {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applyValues];
}

- (void)applyValues {
    self.roomNameLabel.text = self.room.name;
    self.roomCapacityLabel.text = [NSString stringWithFormat:@"%@ %@", [self.room.capacity stringValue], NSLocalizedString(@"personnes", @"personnes")];
    self.roomLocationNameLabel.text = self.room.locationName;

    [self.roomNameLabel sizeToFit];
    [self.roomCapacityLabel sizeToFit];
    [self.roomLocationNameLabel sizeToFit];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), CGRectGetMaxY(self.roomCapacityLabel.frame) + 8.0);
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
}

- (XBArrayDataSource *)buildDataSource {
    return [XBConferenceRoomDetailDataSource dataSourceWithResourcePath:[self pathForLocalDataSource] roomName:self.room.name];
}

- (NSString *)pathForLocalDataSource {
    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"presentations"];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XBConferencePresentationCell";
    return CellIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferencePresentationCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    [(XBConferencePresentationCell *) cell configureWithPresentation:self.dataSource[indexPath.row]];
}

- (void)onSelectCell: (UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowPresentationDetail" sender:nil];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    XBConferencePresentation *presentation = self.dataSource[selectedIndexPath.row];
    XBConferencePresentationDetailViewController *vc = segue.destinationViewController;
    vc.conference = self.conference;
    vc.presentation = presentation;
}

@end