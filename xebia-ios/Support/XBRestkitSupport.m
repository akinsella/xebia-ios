//
//  XBRestkitSupport.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 07/25/12
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

NSString* const XBErrorDomain = @"fr.xebia.ErrorDomain";

#import "XBRestkitSupport.h"
#import "WPPost.h"
#import "WPAuthor.h"
#import "WPCategory.h"
#import "WPTag.h"
#import "TTTweet.h"
#import "GHRepository.h"
#import "NSDateFormatter+XBAdditions.h"
#import "EBEvent.h"

@implementation XBRestkitSupport

+ (void) configure {
    [self configureLoggers];
    [self configureDateFormatters];
    [self configureObjectManager];
    [self configureMappings];
}

+ (void)configureLoggers {
    RKLogConfigureByName("RestKit/*", RKLogLevelInfo);
//    RKLogConfigureByName("RestKit/UI", RKLogLevelError);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelError);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
//    RKLogConfigureByName("RestKit/ObjectMapping/JSON", RKLogLevelError);

//    RKLogConfigureByName("RestKit/UI", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping/JSON", RKLogLevelTrace);
}

+ (void)configureDateFormatters {

    // EventBrite date format: 2012-09-14 05:28:08
    // Wordpress date format: 2012-07-20 06:30:13
    [RKObjectMapping addDefaultDateFormatter: [NSDateFormatter initWithDateFormat: @"yyyy-MM-dd HH:mm:ss"]];

    // Twitter date format: Wed Aug 29 21:32:43 +0000 2012
    [RKObjectMapping addDefaultDateFormatter: [NSDateFormatter initWithDateFormat: @"eee MMM dd HH:mm:ss ZZZZ yyyy"]];

    // Github date format: 2012-07-05T09:43:24Z
    // Already available in Restkit default formatters
    [RKObjectMapping addDefaultDateFormatter: [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"]];
}

+ (void)configureObjectManager {

    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:@"http://127.0.0.1:9000/v1.0/"];

    objectManager.client.cachePolicy = RKRequestCachePolicyEnabled;
    objectManager.client.requestCache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
//    [objectManager.client.requestCache invalidateAll];
}

+ (void)configureMappings {
    RKObjectMappingProvider *omp = [RKObjectManager sharedManager].mappingProvider;

    RKObjectMapping *ghRepositoryObjectMapping = [GHRepository mapping];
    [omp addObjectMapping:ghRepositoryObjectMapping];
    [omp setObjectMapping:ghRepositoryObjectMapping forResourcePathPattern:@"/github/orgs/:organization/repos"];

    RKObjectMapping *ghUserMapping = [GHUser mapping];
    [omp addObjectMapping:ghUserMapping];
    [omp setObjectMapping:ghUserMapping forResourcePathPattern:@"/github/orgs/:organization/public_members"];

    RKObjectMapping *wpCategoryMapping = [WPCategory mapping];
    [omp addObjectMapping:wpCategoryMapping];
    [omp setObjectMapping:wpCategoryMapping forResourcePathPattern:@"/wordpress/get_category_index/"];

    RKObjectMapping *wpTagMapping = [WPTag mapping];
    [omp addObjectMapping:wpTagMapping];
    [omp setObjectMapping:wpTagMapping forResourcePathPattern:@"/wordpress/get_tag_index/"];

    RKObjectMapping *wpAuthorMapping = [WPAuthor mapping];
    [omp addObjectMapping:wpAuthorMapping];
    [omp setObjectMapping:wpAuthorMapping forResourcePathPattern:@"/wordpress/get_author_index/"];

    RKObjectMapping *wpPostMapping = [WPPost mapping];
    [omp addObjectMapping:wpPostMapping];
    [omp setObjectMapping:wpPostMapping forResourcePathPattern:@"/wordpress/get_recent_posts/?id=:identifier"];
    [omp setObjectMapping:wpPostMapping forResourcePathPattern:@"/wordpress/get_author_posts/?id=:identifier"];
    [omp setObjectMapping:wpPostMapping forResourcePathPattern:@"/wordpress/get_tag_posts/?id=:identifier"];
    [omp setObjectMapping:wpPostMapping forResourcePathPattern:@"/wordpress/get_category_posts/?id=:identifier"];

    RKObjectMapping *ttTweet = [TTTweet mapping];
    [omp addObjectMapping:ttTweet];
    [omp setObjectMapping:ttTweet forResourcePathPattern:@"/twitter/user/:user"];

    RKObjectMapping *ebEvent = [EBEvent mapping];
    [omp addObjectMapping:ebEvent];
    [omp setObjectMapping:ebEvent forResourcePathPattern:@"/event/list"];
}

@end
