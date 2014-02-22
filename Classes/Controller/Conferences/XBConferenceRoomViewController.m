//
//  XBConferenceRoomViewController.m
//  Xebia
//
//  Created by Simone Civetta on 29/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRoomViewController.h"
#import "XBConferenceDownloader.h"
#import "XBConferenceRoomDataSource.h"
#import "XBConference.h"
#import "XBConferenceRoomCell.h"

@interface XBConferenceRoomViewController ()

@end

@implementation XBConferenceRoomViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/rooms"];
}

- (void)viewDidLoad {
    
    self.delegate = self;
    self.title = NSLocalizedString(@"Rooms", nil);
    
    [super viewDidLoad];
}

- (void)initialize {
    [super initialize];
    [self applyTheme];
}

- (void)applyTheme {
    
}

- (NSString *)pathForLocalDataSource
{
    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"rooms"];
}

- (XBArrayDataSource *)buildDataSource {
    return [XBConferenceRoomDataSource dataSourceWithResourcePath:[self pathForLocalDataSource]];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XBConferenceRoomCell";
    return CellIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferenceRoomCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    [(XBConferenceRoomCell *)cell configureWithRoom:self.dataSource[indexPath.row]];
}


@end
