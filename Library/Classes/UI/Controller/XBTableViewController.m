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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
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

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
//    self.tableView.backgroundColor = [UIColor colorWithHex:@"#191919" alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

    [self.delegate configureCell:cell atIndex:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    XBLog(@"tableView:heightForRowAtIndexPath: %@", indexPath);
    if (self.fixedRowHeight) {
        return self.tableView.rowHeight;
    }

    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell respondsToSelector:@selector(heightForCell:)] ? [cell heightForCell: tableView] : self.tableView.rowHeight;
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