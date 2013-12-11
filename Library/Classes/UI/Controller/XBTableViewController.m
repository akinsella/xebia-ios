//
//  XBTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "UIColor+XBAdditions.h"
#import "UITableViewCell+VariableHeight.h"
#import "XBToolkit.h"
#import "XBArrayDataSource.h"
#import "XBTableViewController.h"
#import "UIViewController+XBAdditions.h"
#import "XBTableView.h"
#import "XBLogging.h"
#import <objc/runtime.h>


@interface XBTableViewController ()

@property(nonatomic, strong)XBArrayDataSource *dataSource;
@property(nonatomic, strong)NSMutableArray *nibNames;

@end

@implementation XBTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.fixedRowHeight = NO;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.fixedRowHeight = NO;
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fixedRowHeight = NO;
    }

    return self;
}

- (void)viewDidLoad {
    self.nibNames = [@[] mutableCopy];
    [super viewDidLoad];
    [self initialize];
    [self configureTableView];
    [self loadData];
}

- (NSString *)trackPath {
    return @"<NO_TRACK_PATH>";
}

- (void)viewWillAppear:(BOOL)animated {
    [self.appDelegate trackView:self.trackPath];

    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}

-(void)loadData {
    [self.tableView reloadData];
}

-(void)initialize {
    _dataSource = [self buildDataSource];
}

- (XBArrayDataSource *)buildDataSource {
    mustOverride();
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if ([self.tableView respondsToSelector:@selector(setEmptyView:)]) {
        ((XBTableView *)self.tableView).emptyView = [[NSBundle mainBundle] loadNibNamed:@"XBEmptyView" owner:nil options:nil][0];
        ((XBTableView *)self.tableView).emptyView.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
    }
    else {
        XBLogDebug(@"Table view is not an XBTableView instance !: Classe:%@", NSStringFromClass(self.tableView.class));
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    XBLog(@"tableView:cellForRowAtIndexPath: %@", indexPath);
    NSString *cellNibName = [self.delegate tableView:tableView cellNibNameAtIndexPath:indexPath];
    NSString *reuseIdentifier = [self.delegate tableView:tableView cellReuseIdentifierAtIndexPath:indexPath];

    if (![self.nibNames containsObject: cellNibName]) {
        UINib *nib = [UINib nibWithNibName:cellNibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
        [self.nibNames addObject: cellNibName];
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];

    if (!cell) {
        // fix for rdar://11549999 (registerNib… fails on iOS 5 if VoiceOver is enabled)
        cell = [[NSBundle bundleForClass:self.class] loadNibNamed:cellNibName owner:self options:nil][0];
    }

    [cell setBackgroundColor:[UIColor clearColor]];
    [self.delegate configureCell:cell atIndex:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    XBLog(@"tableView:heightForRowAtIndexPath: %@", indexPath);
    if (self.fixedRowHeight) {
        return self.tableView.rowHeight;
    }

    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(heightForCell:)]) {
        CGFloat height = [cell heightForCell: tableView];
        return height;
    }
    else {
        return self.tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(onSelectCell:forObject:withIndex:)]) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

        [self.delegate onSelectCell:cell forObject:self.dataSource[(NSUInteger)indexPath.row] withIndex:indexPath];
    }
}

- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end