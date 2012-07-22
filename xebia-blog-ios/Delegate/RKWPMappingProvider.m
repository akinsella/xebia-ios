//
//  RKGHMappingProvider.m
//  RKGithub
//
//  Created by Blake Watters on 2/16/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKWPMappingProvider.h"
#import "RKWPPost.h"

@implementation RKWPMappingProvider

@synthesize objectStore;

+ (id)mappingProviderWithObjectStore:(RKManagedObjectStore *)objectStore {
    return [[self alloc] initWithObjectStore:objectStore];    
}

- (id)initWithObjectStore:(RKManagedObjectStore *)theObjectStore {
    self = [super init];
    if (self) {
        self.objectStore = theObjectStore;
        
        [self setObjectMapping:[self postObjectMapping] 
        forResourcePathPattern:@"/repos/:user/:repo/issues" 
         withFetchRequestBlock:^NSFetchRequest *(NSString *resourcePath) {
            // NOTE: We could use RKPathMatcher here to easily tokenize the requested resourcePath
            NSFetchRequest *fetchRequest = [RKWPPost fetchRequest];
            fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
            return fetchRequest;
        }];
    }
    
    return self;
}

- (RKManagedObjectMapping *)postObjectMapping {
    RKManagedObjectMapping *mapping =  [RKManagedObjectMapping mappingForEntityWithName:@"RKWPPost" 
                                                                   inManagedObjectStore:self.objectStore];
    
    mapping.primaryKeyAttribute = @"id";
    
    [mapping mapKeyPathsToAttributes:
                        @"id", @"id",
                      @"type", @"type",
                      @"slug", @"slug",
                       @"url", @"url",
                    @"status", @"status",
                     @"title", @"title",
               @"title_plain", @"title_plain",
                   @"content", @"content",
                   @"excerpt", @"excerpt",
                      @"date", @"date",
                  @"modified", @"modified",
             @"comment_count", @"comment_count",
            @"comment_status", @"comment_status",
                          nil];
    
    return mapping;
}

@end
