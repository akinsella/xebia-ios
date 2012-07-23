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
#import "Tag.h"
#import "Category.h"
#import "Author.h"

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

- (NSMutableArray *)fetchTags {
    NSArray *jsonTags = [self fetchIndexData:@"/get_tag_index/" data:@"tags"];

    NSMutableArray *tags = [[[NSMutableArray alloc] initWithCapacity:[jsonTags count]] autorelease];

    for (NSDictionary *jsonTag in jsonTags) {

        Tag *tag = [Tag tagWithId:((NSNumber *)[jsonTag objectForKey:@"id"]).intValue
                             slug:[jsonTag objectForKey:@"slug"] 
                            title:[jsonTag objectForKey:@"title"] 
                      description:[jsonTag objectForKey:@"description"] 
                        postCount:((NSNumber *)[jsonTag objectForKey:@"post_count"]).intValue
        ];
        
        [tags addObject: tag];
        
        [tag release];
    }

    return tags;
}

- (NSMutableArray *)fetchCategories {
    NSArray *jsonCategories = [self fetchIndexData:@"/get_category_index/" data:@"categories"];

    NSMutableArray *categories = [[[NSMutableArray alloc] initWithCapacity:[jsonCategories count]] autorelease];

    for (NSDictionary *jsonCateogy in jsonCategories) {

        Category *category = [Category categoryWithId:((NSNumber *) [jsonCateogy objectForKey:@"id"]).intValue
                                                 slug:[jsonCateogy objectForKey:@"slug"]
                                                title:[jsonCateogy objectForKey:@"title"]
                                          description:[jsonCateogy objectForKey:@"description"]
                                            postCount:((NSNumber *) [jsonCateogy objectForKey:@"post_count"]).intValue
        ];

        [categories addObject: category];

        [category release];
    }

    return categories;
}


- (NSMutableArray *)fetchAuthors {
    NSArray *jsonAuthors = [self fetchIndexData:@"/get_author_index/" data:@"authors"];
    NSMutableArray *authors = [[[NSMutableArray alloc] initWithCapacity:[jsonAuthors count]] autorelease];

    for (NSDictionary *jsonAuthor in jsonAuthors) {

        Author *author = [Author authorWithId:((NSNumber *) [jsonAuthor objectForKey:@"id"]).intValue
                slug:[jsonAuthor objectForKey:@"slug"]
                name:[jsonAuthor objectForKey:@"name"]
                firstname:[jsonAuthor objectForKey:@"first_name"]
                lastname:[jsonAuthor objectForKey:@"last_name"]
                nickname:[jsonAuthor objectForKey:@"nickname"]
                url:[jsonAuthor objectForKey:@"url"]
                description:[jsonAuthor objectForKey:@"descrition"]
        ];

        [authors addObject: author];

        [author release];
    }

    return authors;
}

- (NSArray *)fetchIndexData:(NSString *)urlPath data:(NSString *)data {
    NSDictionary *items = [self fetchJsonData:urlPath];

    NSLog(@"Json Dictionary Fetched %@", items);
    NSLog(@"Dictionary Count %i", [items count]);
    NSArray *jsonAuthors = [items objectForKey:data];
    NSLog([NSString stringWithFormat:@"%@(s) Found %@", data, jsonAuthors]);
    NSLog([NSString stringWithFormat:@"%@(s) Count %i", data, [jsonAuthors count]]);

    return jsonAuthors;
}

- (void)dealloc {
    [baseApiUrl release];
    [super dealloc];
}

@end
