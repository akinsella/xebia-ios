//
//  WPDataAccessor.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 18/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPDataAccessor.h"
#import <RestKit/RestKit.h>
#import "JSONKit.h"

@implementation WPDataAccessor

@synthesize baseApiUrl;

+ (id) initWithBaseApiUrl:(NSString *)url {
    return ([[[WPDataAccessor alloc] initWithBaseApiUrl: url] autorelease]);
}

- (id)initWithBaseApiUrl:(NSString *)url
{
    if((self = [super init]) == NULL) {
        return(NULL);
    }
    
    if([url length] == 0) { 
        [self autorelease]; 
        [NSException raise:NSInvalidArgumentException format:@"Invalid parse options."]; 
    }
    
    [self setBaseApiUrl:url];
    
    return(self);
}

- (NSString *)getApiCallPath:(NSString *)relativeApiCallPath {
    NSString *jsonUrl = [NSString stringWithFormat:@"%@%@", baseApiUrl, relativeApiCallPath];
    NSLog(@"Json Url: %@", jsonUrl);
    
    return jsonUrl;
}

-(NSDictionary *)fetchJsonData:(NSString *)apiCallPath {
    NSError *err = nil;
    
    NSURLResponse* response = nil;
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL* URL = [NSURL URLWithString:[self getApiCallPath:apiCallPath]];
    [request setURL:URL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *items = [jsonKitDecoder objectWithData:jsonData];

    return items;
}

- (NSMutableArray *)fetchPostsWithPostType:(POST_TYPE)postType Id:(int)identifier Count:(int)count
{
    NSString *postTypeStr = [self getPostTypeAsString:postType];
    NSString *postUrlPath = [NSString stringWithFormat:@"/get_%@_posts/?id=%i&count=%i", postTypeStr, identifier, count];
    
    NSArray *jsonPosts = [self fetchIndexData:postUrlPath data:@"posts"];
    
    NSMutableArray *posts = [[[NSMutableArray alloc] initWithCapacity:[jsonPosts count]] autorelease];
    
    for (NSDictionary *jsonPost in jsonPosts) {
        Post *post = [Post deserializeFromJson:jsonPost];
        [posts addObject:post];
        [post release];
    }
    
    return posts;    
}

- (NSString *)getPostTypeAsString:(POST_TYPE)postType {
    switch (postType) {
        case TAG:
            return @"tag";
            break;
        case AUTHOR:
            return @"author";
            break;
        case CATEGORY:
            return @"category";
            break;
            
        default:
            break;
    }
    
}

- (NSArray *)fetchIndexData:(NSString *)urlPath data:(NSString *)data {
    NSDictionary *items = [self fetchJsonData:urlPath];

    NSLog(@"Json Dictionary Fetched %@", items);
    NSLog(@"Dictionary Count %i", [items count]);
    NSArray *jsonAuthors = [items objectForKey:data];
    NSLog(@"%@(s) Found %@", data, jsonAuthors);
    NSLog(@"%@(s) Count %i", data, [jsonAuthors count]);

    return jsonAuthors;
}

- (void)dealloc {
    [baseApiUrl release];
    [super dealloc];
}

@end
