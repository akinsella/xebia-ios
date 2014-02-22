//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceTrackDetailViewController.h"
#import "XBConferenceTrack.h"
#import "DTAttributedTextContentView.h"
#import "NSAttributedString+HTML.h"
#import "XBConferenceTrackDetailDataSource.h"
#import "XBConferenceDownloader.h"
#import "XBConference.h"
#import "XBConferencePresentation.h"
#import "XBConferencePresentationCell.h"


@implementation XBConferenceTrackDetailViewController

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
    self.trackTitleLabel.text = self.track.name;

    NSData *data = [[NSString stringWithFormat:@"%@%@%@", @"<font face='HelveticaNeue'>", self.track.description, @"</font>"] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{DTUseiOS6Attributes: @(YES)};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    self.trackDescriptionLabel.attributedString = attributedString;
    [self.trackDescriptionLabel sizeToFit];
}

- (XBArrayDataSource *)buildDataSource {
    return [XBConferenceTrackDetailDataSource dataSourceWithResourcePath:[self pathForLocalDataSource] trackName:self.track.name];
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

@end