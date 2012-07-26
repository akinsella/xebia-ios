//
//  RKGHMappingProvider.m
//  RKGithub
//
//  Created by Blake Watters on 2/16/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKWPMappingProvider.h"
#import "RKWPPost.h"
#import "RKWPAuthor.h"
#import "RKWPCategory.h"
#import "RKWPTag.h"

@implementation RKWPMappingProvider

@synthesize objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore {
    return [[self alloc] initWithObjectStore:objectStore];    
}

- (id)initWithObjectStore:(RKManagedObjectStore *)theObjectStore {
    self = [super init];
    if (self) {
        self.objectStore = theObjectStore;
        
        [self setObjectMapping:[self categoryObjectMapping] 
        forResourcePathPattern:@"/get_category_index/" 
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [RKWPCategory fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
             return fetchRequest;
         }];
        
        
        [self setObjectMapping:[self tagObjectMapping] 
        forResourcePathPattern:@"/get_tag_index/" 
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [RKWPTag fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
             return fetchRequest;
         }];
        
        
        [self setObjectMapping:[self authorObjectMapping] 
        forResourcePathPattern:@"/get_author_index/" 
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
             // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
             NSFetchRequest *fetchRequest = [RKWPAuthor fetchRequest];
             fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
             return fetchRequest;
         }];
        
        
        [self setObjectMapping:[self postObjectMapping] 
        forResourcePathPattern:@"/get_recent_posts/" 
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
            NSFetchRequest *fetchRequest = [RKWPPost fetchRequest];
            fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
            return fetchRequest;
        }];
    }
    
    return self;
}

- (RKManagedObjectMapping *)categoryObjectMapping {
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"RKWPCategory" 
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
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"RKWPTag" 
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
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"RKWPAuthor" 
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
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"RKWPPost" 
                                                                   inManagedObjectStore:self.objectStore];
    mapping.rootKeyPath = @"posts";
    mapping.primaryKeyAttribute = @"identifier";
    [mapping mapAttributes:@"type", @"slug", @"url", @"status", @"title", @"title_plain", @"content", @"excerpt", @"date", @"modified", @"comment_count", @"comment_status", nil];
    [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     nil];
    
    return mapping;
}

@end
