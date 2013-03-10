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
#import "JSONKit.h"

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

- (int)maxDataAgeInSecondsBeforeServerFetch {
    return 120;
}

- (Class)dataClass {
    return [GHOwner class];
}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *cellReuseIdentifier = @"GHOwner";

    return cellReuseIdentifier;
}

- (NSString *)storageFileName {
    return @"gh-owners.json";
}

- (NSString *)cellNibName {
    return @"GHOwnerCell";
}

- (NSString *)resourcePath {
    return @"/api/github/owners";
}

//- (NSDictionary *)fetchDataFromDB {
////    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
////    return [[self dataClass] MR_findAllSortedBy:@"login" ascending:YES inContext:localContext];
//
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"gh-owners.json"];
//    NSLog(@"GHOwners Json path: %@", filePath);
//
//    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSDictionary *json = [fileContent objectFromJSONString];
//
//    return json;
//}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {

    GHOwnerCell * ownerCell = (GHOwnerCell *) cell;

    GHOwner *owner = [self objectAtIndex:(NSUInteger) indexPath.row];
    ownerCell.titleLabel.text = owner.login;
    ownerCell.identifier = owner.identifier;

    [ownerCell.imageView setImageWithURL:[owner avatarImageUrl] placeholderImage:self.defaultAvatarImage];
}

@end