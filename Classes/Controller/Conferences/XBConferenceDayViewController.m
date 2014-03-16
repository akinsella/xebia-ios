//
//  XBConferenceDayViewController.m
//  Xebia
//
//  Created by Simone Civetta on 21/02/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceDayViewController.h"
#import "XBConferencePresentationCell.h"
#import "XBConferenceDownloader.h"
#import "XBConferenceScheduleDataSource.h"
#import "XBConferencePresentationDetailViewController.h"

@interface XBConferenceDayViewController ()

@end

@implementation XBConferenceDayViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/day"];
}

- (void)viewDidLoad {
    
    self.delegate = self;
    self.title = NSLocalizedString(@"Day", nil);
    [super viewDidLoad];
}

- (void)initialize {
    [super initialize];
    [self applyTheme];
}

- (void)applyTheme {
    
}

- (void)filterByDay {
    [(XBConferenceScheduleDataSource *)self.dataSource loadAndFilterByDay:self.day callback:^{
        [self.tableView reloadData];
    }];
}

- (NSString *)pathForLocalDataSource {
    XBConferenceDownloader *downloader = [XBConferenceDownloader downloaderWithDownloadableBundle:self.conference];
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"schedule"];
}

- (XBArrayDataSource *)buildDataSource {
    return [XBConferenceScheduleDataSource dataSourceWithResourcePath:[self pathForLocalDataSource]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applyValues];
}

- (void)applyValues {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"fr_FR"];
    dateFormatter.dateFormat = @"EEEE dd LLLL";
    self.dayLabel.text = [dateFormatter stringFromDate:self.day];
    
    [self filterByDay];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XBConferencePresentationCell";
    return CellIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferencePresentationCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    [(XBConferencePresentationCell *)cell configureWithPresentation:self.dataSource[indexPath.row]];
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
