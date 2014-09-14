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
#import "NSDateFormatter+XBAdditions.h"
#import "XBConferencePresentationSlotDataSource.h"
#import "XBConferencePresentationSlot.h"
#import "UIColor+XBConferenceAdditions.h"

@interface XBConferenceDayViewController ()

@end

@implementation XBConferenceDayViewController

- (NSString *)trackPath {
    NSDateFormatter *dateFormatter = [NSDateFormatter initWithDateFormat:@"YYYY-MM-dd"];
    return [NSString stringWithFormat:@"/days/%@", [dateFormatter stringFromDate:self.day]];
}

- (void)viewDidLoad {
    self.delegate = self;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    dateFormatter.dateFormat = @"EEEE dd LLLL";

    self.title = NSLocalizedString([dateFormatter stringFromDate:self.day], nil);
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
    return [[downloader bundleFolderPath] stringByAppendingPathComponent:@"schedule"];
}

- (XBArrayDataSource *)buildDataSource {
    XBConferencePresentationSlotDataSource *dataSource = [XBConferencePresentationSlotDataSource dataSourceWithResourcePath:[self pathForLocalDataSource]];
    dataSource.day = self.day;
    return dataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applyValues];
}

- (void)applyValues {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    dateFormatter.dateFormat = @"EEEE dd LLLL";
    self.dayLabel.text = [[dateFormatter stringFromDate:self.day] capitalizedString];
    
//    [self filterByDay];
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XBConferencePresentationCell";
    return CellIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferencePresentationCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    [(XBConferencePresentationCell *)cell configureWithPresentation:self.dataSource[indexPath.section][indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(header.bounds, 10, 0)];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    label.textColor = [UIColor xebiaPurpleColor];
    XBConferencePresentationSlot *slot = self.dataSource[section];
    label.text = slot.dateFormatted;
    [header addSubview:label];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (void)onSelectCell: (UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    XBConferencePresentation *presentation = self.dataSource[indexPath.section][indexPath.row];
    
    if ([presentation isAuxiliary]) {
        return;
    }
    
    [self performSegueWithIdentifier:@"ShowPresentationDetail" sender:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    XBConferencePresentation *presentation = self.dataSource[selectedIndexPath.section][selectedIndexPath.row];
    XBConferencePresentationDetailViewController *vc = segue.destinationViewController;
    vc.conference = self.conference;
    vc.presentation = presentation;
}

@end
