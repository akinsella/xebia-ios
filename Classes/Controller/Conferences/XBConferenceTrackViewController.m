//
// Created by Simone Civetta on 09/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceTrackViewController.h"
#import "XBConference.h"
#import "XBConferenceDownloader.h"
#import "XBConferenceTrackDataSource.h"
#import "XBConferenceTrackCell.h"


@implementation XBConferenceTrackViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/tracks"];
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

- (NSString *)pathForLocalDataSource {
    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"tracks"];
}

- (XBArrayDataSource *)buildDataSource {
    return [XBConferenceTrackDataSource dataSourceWithResourcePath:[self pathForLocalDataSource]];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XBConferenceTrackCell";
    return CellIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferenceTrackCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    [(XBConferenceTrackCell *)cell configureWithTrack:self.dataSource[indexPath.row]];
}

@end