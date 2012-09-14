//
//  GHMappingProvider.m
//  RKGithub
//
//  Created by Blake Watters on 2/16/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "XBMappingProvider.h"
#import "WPPost.h"
#import "WPAuthor.h"
#import "WPCategory.h"
#import "WPTag.h"
#import "TTTweet.h"
#import "GHRepository.h"

@implementation XBMappingProvider

@synthesize objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore {
    return [[self alloc] initWithObjectStore:objectStore];    
}

- (id)initWithObjectStore:(RKManagedObjectStore *)theObjectStore {
    self = [super init];
    if (self) {
        self.objectStore = theObjectStore;
        
        [self setObjectMapping:[self categoryObjectMapping] 
        forResourcePathPattern:@"/wordpress/get_category_index/" 
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [WPCategory fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
             return fetchRequest;
         }];
        
        
        [self setObjectMapping:[self tagObjectMapping] 
        forResourcePathPattern:@"/wordpress/get_tag_index/" 
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [WPTag fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
             return fetchRequest;
         }];
        
        
        [self setObjectMapping:[self authorObjectMapping] 
        forResourcePathPattern:@"/wordpress/get_author_index/" 
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [WPAuthor fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
             return fetchRequest;
         }];
        
        [self setObjectMapping:[self postObjectMapping]
        forResourcePathPattern:@"/wordpress/get_recent_posts/"
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [WPPost fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
             return fetchRequest;
         }];
        
        [self setObjectMapping:[self postObjectMapping]
        forResourcePathPattern:@"/wordpress/get_author_posts/"
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slug == %@", @"akinsella"];
             NSFetchRequest *fetchRequest = [GHUser fetchRequest];
             [fetchRequest setPredicate:predicate];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
             return fetchRequest;
         }];
        
        [self setObjectMapping:[self postObjectMapping]
        forResourcePathPattern:@"/wordpress/get_tag_posts/"
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slug == %@", @"android"];
             NSFetchRequest *fetchRequest = [GHUser fetchRequest];
             [fetchRequest setPredicate:predicate];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
             return fetchRequest;
         }];
        
        [self setObjectMapping:[self postObjectMapping]
        forResourcePathPattern:@"/wordpress/get_category_posts/"
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slug == %@", @"web"];
             NSFetchRequest *fetchRequest = [GHUser fetchRequest];
             [fetchRequest setPredicate:predicate];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
             return fetchRequest;
         }];
        
        [self setObjectMapping:[self tweetObjectMapping]
        forResourcePathPattern:@"/twitter/XebiaFR/"
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [TTTweet fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:NO]];
             return fetchRequest;
         }];
        
        [self setObjectMapping:[self githubRepositoryObjectMapping]
        forResourcePathPattern:@"/github/orgs/xebia-france/repos"
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [GHRepository fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]];
             return fetchRequest;
         }];

        [self setObjectMapping:[self githubUserObjectMapping]
        forResourcePathPattern:@"/github/orgs/xebia-france/public_members"
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", @"User"];
             NSFetchRequest *fetchRequest = [GHUser fetchRequest];
             [fetchRequest setPredicate:predicate];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]];
             return fetchRequest;
         }];
    }
    
    return self;
}

- (RKManagedObjectMapping *)categoryObjectMapping {
    RKManagedObjectMapping *mapping = [RKManagedObjectMapping mappingForEntityWithName:@"WPCategory" 
                                                                   inManagedObjectStore:self.objectStore];
    mapping.rootKeyPath = @"categories";
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes:@"slug", @"title", @"parent", @"post_count", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     @"description", @"description_",
     nil];
    
    return mapping;
}

- (RKManagedObjectMapping *)tagObjectMapping {
    RKManagedObjectMapping *mapping = [RKManagedObjectMapping mappingForEntityWithName:@"WPTag" 
                                                                   inManagedObjectStore:self.objectStore];
    mapping.rootKeyPath = @"tags";
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes:@"slug", @"title", @"post_count", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     @"description", @"description_",
     nil];
    
    return mapping;
}

- (RKManagedObjectMapping *)authorObjectMapping {
    RKManagedObjectMapping *mapping = [RKManagedObjectMapping mappingForEntityWithName:@"WPAuthor" 
                                                                   inManagedObjectStore:self.objectStore];
    mapping.rootKeyPath = @"authors";
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes:@"slug", @"name", @"first_name", @"last_name", @"nickname", @"url", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     @"description", @"description_",
     nil];
    
    return mapping;
}

- (RKManagedObjectMapping *)postObjectMapping {
    RKManagedObjectMapping *mapping = [RKManagedObjectMapping mappingForEntityWithName:@"WPPost"
                                                                   inManagedObjectStore:self.objectStore];
    mapping.rootKeyPath = @"posts";
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes:@"type", @"slug", @"url", @"status", @"title", @"title_plain", @"content", @"excerpt", @"date", @"modified", @"comment_count", @"comment_status", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     nil];
    
    return mapping;
}

- (RKManagedObjectMapping *)tweetObjectMapping {
    RKManagedObjectMapping *mapping = [RKManagedObjectMapping mappingForEntityWithName:@"TTTweet"
                                                                  inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes: @"text", @"created_at", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     nil];
    
    // Relationships
    [mapping mapKeyPath:@"user" toRelationship:@"user" withMapping:[self tweetUserObjectMapping]];
    
    return mapping;
}

- (RKManagedObjectMapping *)tweetUserObjectMapping {
    RKManagedObjectMapping *mapping = [RKManagedObjectMapping mappingForEntityWithName:@"TTUser"
                                                                  inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes: @"screen_name", @"name", @"profile_image_url", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     nil];

    return mapping;
}

- (RKManagedObjectMapping *)githubRepositoryObjectMapping {
    RKManagedObjectMapping *mapping = [RKManagedObjectMapping mappingForEntityWithName:@"GHRepository"
                                                                  inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes: @"text", @"language", /* @"pushed_at", */ /*@"created_at",*/ @"forks", @"mirror_url", @"has_wiki", @"clone_url", @"watchers", @"ssh_url", /* @"updated_at" ,*/ @"open_issues", @"git_url", @"has_issues", @"html_url", /* @"watchers_count",*/ @"size", @"fork", @"full_name", @"forks_count", @"has_downloads", @"svn_url", @"name", @"url", @"open_issues_count", @"homepage", nil];
    [mapping mapKeyPathsToAttributes:
        @"id", @"identifier",
        @"description", @"description_",
        @"private", @"private_",
     nil];
    
    // Relationships
    [mapping mapKeyPath:@"owner" toRelationship:@"owner" withMapping:[self githubUserObjectMapping]];
    
    return mapping;
}

- (RKManagedObjectMapping *)githubUserObjectMapping {
    RKManagedObjectMapping *mapping = [RKManagedObjectMapping mappingForEntityWithName:@"GHUser"
                                                                  inManagedObjectStore:self.objectStore];
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes: @"created_at", @"type", @"bio", @"login", @"public_gists", @"email", @"gravatar_id", @"public_repos", @"html_url", @"followers", @"avatar_url", @"name", @"url", @"name", @"url", @"company", @"hireable", @"following", @"blog", @"location", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     nil];
    
    return mapping;
}

@end
