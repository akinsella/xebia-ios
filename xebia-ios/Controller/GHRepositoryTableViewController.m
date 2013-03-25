//
//  GHRepositoryTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepository.h"
#import "GHRepositoryTableViewController.h"
#import "GHRepositoryCell.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "NSDateFormatter+XBAdditions.h"

@interface GHRepositoryTableViewController()
@property (nonatomic, strong) UIImage* xebiaAvatarImage;
@end

@implementation GHRepositoryTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Repositories";
    self.xebiaAvatarImage = [UIImage imageNamed:@"xebia-avatar"];

    [super viewDidLoad];
}


- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *const cellReuseIdentifier = @"GHRepository";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"GHRepositoryCell";
}

- (UIImage *)defaultImage {
    return [UIImage imageNamed:@"xebia-avatar"];
}

- (XBHttpArrayDataSourceConfiguration *)configuration {

    XBHttpArrayDataSourceConfiguration* configuration = [XBHttpArrayDataSourceConfiguration configuration];
    configuration.resourcePath = @"/api/github/repositories";
    configuration.storageFileName = @"gh-repositories.json";
    configuration.maxDataAgeInSecondsBeforeServerFetch = 120;
    configuration.typeClass = [GHRepository class];
    configuration.dateFormat = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    return configuration;
}

- (void)configureCell: (UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    GHRepositoryCell *repositoryCell = (GHRepositoryCell *)cell;
    GHRepository *repository = self.dataSource[indexPath.row];
    repositoryCell.titleLabel.text = repository.name;
    repositoryCell.descriptionLabel.text = repository.description_;
    repositoryCell.identifier = repository.identifier;
    [repositoryCell.imageView setImage:self.defaultImage];
}

@end