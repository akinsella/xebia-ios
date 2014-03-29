//
// Created by Simone Civetta on 26/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceSpeakerViewController.h"
#import "XBConferenceSpeakerCell.h"
#import "XBConference.h"
#import "XBConferenceDownloader.h"
#import "XBConferenceSpeakerDataSource.h"
#import "XBConferenceSpeaker.h"
#import "XBConferenceSpeakerDetailViewController.h"


@implementation XBConferenceSpeakerViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/speakers"];
}

- (void)viewDidLoad {

    self.delegate = self;
    self.fixedRowHeight = YES;
    self.title = NSLocalizedString(@"Speakers", nil);

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
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"speakers"];
}

- (XBArrayDataSource *)buildDataSource {
    return [XBConferenceSpeakerDataSource dataSourceWithResourcePath:[self pathForLocalDataSource]];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XBConferenceSpeakerCell";
    return CellIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferenceSpeakerCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    [(XBConferenceSpeakerCell *)cell configureWithSpeaker:self.dataSource[indexPath.row]];
}

- (void)onSelectCell:(UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowSpeakerDetails" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    XBConferenceSpeaker *speaker = self.dataSource[selectedIndexPath.row];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];

    XBConferenceSpeakerDetailViewController *vc = segue.destinationViewController;
    vc.speaker = speaker;
    vc.conference = self.conference;
}

@end