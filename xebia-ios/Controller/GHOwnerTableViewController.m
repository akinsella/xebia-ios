//
//  GHOwnerTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHOwner.h"
#import "GHOwnerTableViewController.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "GHOwnerCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "NSDateFormatter+XBAdditions.h"

@interface GHOwnerTableViewController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation GHOwnerTableViewController

- (void)viewDidLoad {

    self.delegate = self;
    self.title = @"Owners";
    self.defaultAvatarImage = [UIImage imageNamed:@"github-gravatar-placeholder"];

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"GHOwner";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"GHOwnerCell";
}

- (XBHttpArrayDataSourceConfiguration *)configuration {

    XBHttpArrayDataSourceConfiguration* configuration = [XBHttpArrayDataSourceConfiguration configuration];
    configuration.resourcePath = @"/api/github/owners";
    configuration.storageFileName = @"gh-owners.json";
    configuration.maxDataAgeInSecondsBeforeServerFetch = 120;
    configuration.typeClass = [GHOwner class];
    configuration.dateFormat = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];

    return configuration;
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    GHOwnerCell * ownerCell = (GHOwnerCell *) cell;

    GHOwner *owner = self.dataSource[indexPath.row];
    ownerCell.titleLabel.text = owner.login;
    ownerCell.identifier = owner.identifier;

    [ownerCell.imageView setImageWithURL:[owner avatarImageUrl] placeholderImage:self.defaultAvatarImage];
}

@end