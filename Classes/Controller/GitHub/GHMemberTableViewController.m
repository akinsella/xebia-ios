//
//  GHMemberTableViewController.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 25/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHMember.h"
#import "GHMemberTableViewController.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "GHMemberCell.h"
#import "AFNetworking.h"
#import "XBPListConfigurationProvider.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"
#import "UIViewController+XBAdditions.h"

@interface GHMemberTableViewController ()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation GHMemberTableViewController

- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/github/member"];

    self.delegate = self;
    self.title = @"Members";
    self.defaultAvatarImage = [UIImage imageNamed:@"github-gravatar-placeholder"];

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"GHMember";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"GHMemberCell";
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/github/member"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[GHMember class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    GHMemberCell *memberCell = (GHMemberCell *) cell;

    GHMember *owner = self.dataSource[indexPath.row];
    memberCell.titleLabel.text = owner.login;
    memberCell.identifier = owner.identifier;

    [memberCell.imageView setImageWithURL:[owner avatarImageUrl] placeholderImage:self.defaultAvatarImage];
}

@end