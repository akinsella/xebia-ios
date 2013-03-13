//
//  GHRepositoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepositoryTableViewController.h"
#import "XBArrayDataSource.h"
#import "XBPaginatedTableViewController.h"
#import "XBPaginatedArrayDataSource.h"

@interface XBPaginatedTableViewController ()
@end

@implementation XBPaginatedTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];

    if (self) {
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (XBPaginatedArrayDataSource *)buildDataSource:(NSDictionary *)json {
    return [[XBPaginatedArrayDataSource alloc] initWithJson:json ForType:[self.delegate dataClass]];
}

- (XBPaginatedArrayDataSource *)fetchDataFromDB {
    return [XBPaginatedArrayDataSource initFromFileWithStorageFileName:[self.delegate storageFileName] forType:self.delegate.dataClass];
}


- (void)didReceiveMemoryWarning{
    NSLog(@"Did received a memory warning in controller: %@", [self class]);
    [super didReceiveMemoryWarning];
}

@end