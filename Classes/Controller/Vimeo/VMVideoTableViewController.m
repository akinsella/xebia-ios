//
// Created by Alexis Kinsella on 23/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VMVideoTableViewController.h"
#import "VMVideo.h"
#import "XBBasicHttpQueryParamBuilder.h"
#import "XBConfigurationProvider.h"
#import "XBPListConfigurationProvider.h"
#import "XBHttpJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "GAITracker.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+XBAdditions.h"
#import "VMVideoCell.h"
#import "VMThumbnail.h"
#import "VMVideoDetailsViewController.h"

@interface VMVideoTableViewController()
@property (nonatomic, strong) UIImage* defaultAvatarImage;
@end

@implementation VMVideoTableViewController


- (void)viewDidLoad {

    [self.appDelegate.tracker sendView:@"/vimeo/video"];

    self.delegate = self;
    self.tableView.rowHeight = 75;
    self.title = NSLocalizedString(@"Videos", nil);

    self.defaultAvatarImage = [UIImage imageNamed:@"avatar_placeholder"];

    [self addMenuButton];

    [super viewDidLoad];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"VMVideo";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"VMVideoCell";
}

- (XBArrayDataSource *)buildDataSource {
    XBHttpClient *httpClient = [[XBPListConfigurationProvider provider] httpClient];
    XBBasicHttpQueryParamBuilder *httpQueryParamBuilder = [XBBasicHttpQueryParamBuilder builderWithDictionary:@{}];
    XBHttpJsonDataLoader *dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient httpQueryParamBuilder:httpQueryParamBuilder resourcePath:@"/api/vimeo/video"];
    XBJsonToArrayDataMapper *dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:@"videos.video" typeClass:[VMVideo class]];
    return [XBReloadableArrayDataSource dataSourceWithDataLoader:dataLoader dataMapper:dataMapper];
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    VMVideoCell *videoCell = (VMVideoCell *) cell;
    [videoCell configure];

    VMVideo *video = self.dataSource[(NSUInteger) indexPath.row];
    VMThumbnail *thumbnail = video.thumbnails[0];
    NSURL* thumbnailUrl = [NSURL URLWithString:[thumbnail url]];
    [videoCell.imageView setImageWithURL:thumbnailUrl placeholderImage:self.defaultAvatarImage];

    videoCell.titleLabel.text = video.title;
    videoCell.identifier = video.identifier;
    videoCell.dateLabel.text = video.dateFromNow;
    videoCell.descriptionLabel.text = [NSString stringWithFormat:@"%@%@ lecture(s) - %@ like(s) - %@ commentaire(s)", video.isHd ? @"HD | ": @"", video.playCount, video.likeCount, video.commentCount];
}

-(void)onSelectCell: (UITableViewCell *)cell forObject: (id) object withIndex: (NSIndexPath *)indexPath {
    VMVideo *video = self.dataSource[(NSUInteger) indexPath.row];
    VMVideoDetailsViewController *videoDetailsViewController = (VMVideoDetailsViewController *) [[self appDelegate].viewControllerManager getOrCreateControllerWithIdentifier:@"videoDetails"];
    videoDetailsViewController.video = video;
    [self.navigationController pushViewController:videoDetailsViewController animated:YES];
}


@end