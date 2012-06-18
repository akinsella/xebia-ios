//
//  WPDataAccessor.m
//  StoryboardUITableViewTutorial
//
//  Created by Alexis Kinsella on 18/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WPDataAccessor.h"
#import "JSONKit.h"
#import "Tag.h"

@implementation WPDataAccessor
@synthesize baseApiUrl;

+ (id) initWithBaseApiUrl:(NSString *)url {
    return ([[[WPDataAccessor alloc] initWithBaseApiUrl: url] autorelease]);
}

- (id)initWithBaseApiUrl:(NSString *)url
{
    if((self = [super init]) == NULL) { return(NULL); }
    
    if([url length] == 0) { 
        [self autorelease]; 
        [NSException raise:NSInvalidArgumentException format:@"Invalid parse options."]; 
    }
    
    [self setBaseApiUrl:url];
    
    return(self);
    
errorExit:
    if(self) { [self autorelease]; self = NULL; }
    return(NULL);
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


- (NSMutableArray *)fetchTags {
    NSDictionary *items = [self fetchJsonData:@"/get_tag_index/"];

    NSLog(@"Json Dictionary Fetched %@", items); 
    NSLog(@"Dictionary Count %i", [items count]); 
    NSArray *jsonTags = [items objectForKey:@"tags"];
    NSLog(@"Tags Found %@", jsonTags);
    NSLog(@"Tags Count %i", [jsonTags count]); 

    NSMutableArray *tags = [[NSMutableArray alloc] initWithCapacity:[jsonTags count]];

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

@end
