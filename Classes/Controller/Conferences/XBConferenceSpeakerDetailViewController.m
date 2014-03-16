//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "XBConferenceSpeakerDetailViewController.h"
#import "XBConferenceSpeaker.h"
#import "NSString+XBAdditions.h"
#import "XBConferenceSpeakerTalkCell.h"
#import "XBConferencePresentationDetailViewController.h"
#import "XBConference.h"
#import "XBConferenceSpeakerTalk.h"


@implementation XBConferenceSpeakerDetailViewController

- (NSString *)trackPath {
    return [NSString stringWithFormat:@"/detail"];
}

- (XBArrayDataSource *)buildDataSource {
    return [XBArrayDataSource dataSourceWithArray:self.speaker.talks];
}

- (void)viewDidLoad {
    self.delegate = self;
    self.title = NSLocalizedString(self.speaker.lastName, nil);
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applyValues];
    [self applyTheme];
}

- (void)applyTheme {
    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame) / 2.0;
    self.imageView.clipsToBounds = YES;
}

- (void)applyValues {
    [self.imageView setImageWithURL:[self.speaker.imageURL url] placeholderImage:nil];
    self.firstNameLabel.text = self.speaker.firstName;
    self.lastNameLabel.text = self.speaker.lastName;
    self.companyLabel.text = self.speaker.company;
    self.bioLabel.text = self.speaker.bio;
    
    [self.bioLabel sizeToFit];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), CGRectGetMaxY(self.bioLabel.frame) + 8.0);
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
}

- (NSString *)tableView:(UITableView *)tableView cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XBConferenceSpeakerTalkCell";
    return CellIdentifier;
}

- (NSString *)tableView:(UITableView *)tableView cellNibNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"XBConferenceSpeakerTalkCell";
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    [(XBConferenceSpeakerTalkCell *)cell configureWithTalk:self.dataSource[indexPath.row]];
}

- (void)onSelectCell:(UITableViewCell *)cell forObject:(id)object withIndex:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowPresentationDetail" sender:nil];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    XBConferencePresentationDetailViewController *vc = segue.destinationViewController;
    vc.conference = self.conference;
    vc.presentation = self.dataSource[selectedIndexPath.row];
}

@end