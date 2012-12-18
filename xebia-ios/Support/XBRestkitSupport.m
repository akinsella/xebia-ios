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
    [RKObjectManager sharedManager].acceptMIMEType = RKMIMETypeJSON;
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    
    [self configureLoggers];
    [self configureDateFormatters];
    [self configureObjectManager];
    [self configureMappings];
}

+ (void)configureLoggers {
    RKLogConfigureByName("RestKit/*", RKLogLevelWarning);
//    RKLogConfigureByName("RestKit/*", RKLogLevelTrace);
    
    
//    RKLogConfigureByName("RestKit/UI", RKLogLevelError);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelError);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
//    RKLogConfigureByName("RestKit/ObjectMapping/JSON", RKLogLevelError);

//    RKLogConfigureByName("RestKit/UI", RKLogLevelWarning);
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

//    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:@"http://dev.xebia.fr:9000/api"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:@"http://xebia-mobile-backend.cloudfoundry.com/api"];
    objectManager.client.cachePolicy = RKRequestCachePolicyNone;
//    objectManager.client.requestCache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
//    objectManager.client.serviceUnavailableAlertEnabled = YES;
//    objectManager.client.serviceUnavailableAlertTitle = @"Erreur";
//    objectManager.client.serviceUnavailableAlertMessage = @"Service indisponible. Veuillez réessayer plus tard.";

    [objectManager.client.requestCache invalidateAll];
    
    
}

+ (void)configureMappings {
        RKObjectMappingProvider *omp = [RKObjectManager sharedManager].mappingProvider;

    RKObjectMapping *ghRepositoryObjectMapping = [GHRepository mapping];
    [omp addObjectMapping:ghRepositoryObjectMapping];
    [omp setObjectMapping:ghRepositoryObjectMapping forResourcePathPattern:@"/github/repositories"];
    [omp setSerializationMapping:[ghRepositoryObjectMapping inverseMapping] forClass:[GHRepository class]];

    RKObjectMapping *ghOwnerMapping = [GHOwner mapping];
    [omp addObjectMapping:ghOwnerMapping];
    [omp setObjectMapping:ghOwnerMapping forResourcePathPattern:@"/github/owners"];
    [omp setSerializationMapping:[ghOwnerMapping inverseMapping] forClass:[GHOwner class]];

    RKObjectMapping *wpCategoryMapping = [WPCategory mapping];
    [omp addObjectMapping:wpCategoryMapping];
    [omp setObjectMapping:wpCategoryMapping forResourcePathPattern:@"/wordpress/categories"];
    [omp setSerializationMapping:[wpCategoryMapping inverseMapping] forClass:[WPCategory class]];

    RKObjectMapping *wpTagMapping = [WPTag mapping];
    [omp addObjectMapping:wpTagMapping];
    [omp setObjectMapping:wpTagMapping forResourcePathPattern:@"/wordpress/tags"];
    [omp setSerializationMapping:[wpTagMapping inverseMapping] forClass:[WPTag class]];
    
    RKObjectMapping *wpAuthorMapping = [WPAuthor mapping];
    [omp addObjectMapping:wpAuthorMapping];
    [omp setObjectMapping:wpAuthorMapping forResourcePathPattern:@"/wordpress/authors"];
    [omp setSerializationMapping:[wpAuthorMapping inverseMapping] forClass:[WPAuthor class]];

    RKObjectMapping *wpPostMapping = [WPPost mapping];
    [omp addObjectMapping:wpPostMapping];
    [omp setSerializationMapping:[wpPostMapping inverseMapping] forClass:[WPPost class]];

    [omp setObjectMapping:wpPostMapping forResourcePathPattern:@"/wordpress/posts/recent"];
    [omp setObjectMapping:wpPostMapping forResourcePathPattern:@"/wordpress/author/:identifier/posts"];
    [omp setObjectMapping:wpPostMapping forResourcePathPattern:@"/wordpress/tag/:identifier/posts"];
    [omp setObjectMapping:wpPostMapping forResourcePathPattern:@"/wordpress/category/:identifier/posts"];
    // http://blog.xebia.fr/wp-json-api/get_post/?post_id=12467


    RKObjectMapping *wpPostOneMapping = [WPPost mappingForOne];
    [omp addObjectMapping:wpPostOneMapping];
    [omp setObjectMapping:wpPostOneMapping forResourcePathPattern:@"/wordpress/post/:identifier"];

    RKObjectMapping *ttTweetMapping = [TTTweet mapping];
    [omp addObjectMapping:ttTweetMapping];
    [omp setObjectMapping:ttTweetMapping forResourcePathPattern:@"/twitter/timeline"];
    [omp setSerializationMapping:[ttTweetMapping inverseMapping] forClass:[TTTweet class]];

    RKObjectMapping *ebEventMapping = [EBEvent mapping];
    [omp addObjectMapping:ebEventMapping];
    [omp setObjectMapping:ebEventMapping forResourcePathPattern:@"/eventbrite/events"];
    [omp setSerializationMapping:[ebEventMapping inverseMapping] forClass:[EBEvent class]];
}

@end
