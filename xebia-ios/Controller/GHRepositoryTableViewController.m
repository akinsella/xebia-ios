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
#import "JSONKit.h"

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

- (int)maxDataAgeInSecondsBeforeServerFetch {
    return 120;
}

- (Class)dataClass {
    return [GHRepository class];
}

//- (NSDictionary *)fetchDataFromDB {
////    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
////    return [[self dataClass] MR_findAllSortedBy:@"name" ascending:YES inContext:localContext];
//
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"gh-repositories.json"];
//    NSLog(@"GHRepositories Json path: %@", filePath);
//
//    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSDictionary *json = [fileContent objectFromJSONString];
//
//    return json;
//}

- (NSString *)cellReuseIdentifier {
    // Needs to be static
    static NSString *const cellReuseIdentifier = @"GHRepository";

    return cellReuseIdentifier;
}

- (NSString *)cellNibName {
    return @"GHRepositoryCell";
}

- (NSString *)storageFileName {
    return @"gh-repositories.json";
}

- (NSString *)resourcePath {
    return @"/api/github/repositories";
}

- (UIImage *)defaultImage {
    return [UIImage imageNamed:@"xebia-avatar"];
}

- (void)configureCell: (UITableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    GHRepositoryCell *repositoryCell = (GHRepositoryCell *)cell;
    GHRepository *repository = [self objectAtIndex:(NSUInteger) indexPath.row];
    repositoryCell.titleLabel.text = repository.name;
    repositoryCell.descriptionLabel.text = repository.description_;
    repositoryCell.identifier = repository.identifier;
    [repositoryCell.imageView setImage:self.defaultImage];
}

@end