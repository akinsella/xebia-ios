//
// Created by akinsella on 01/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "XBCacheableDataLoader.h"
#import "XBLogging.h"
#import "XBHttpDataLoader.h"

@interface XBCacheableDataLoader()

@property (nonatomic, strong)NSObject<XBDataLoader> *dataLoader;
@property (nonatomic, strong)XBCache *cache;
@property (nonatomic, strong)NSObject<XBCacheKeyBuilder> *cacheKeyBuilder;
@property (nonatomic, assign)NSTimeInterval ttl;

@end

@implementation XBCacheableDataLoader

+ (id)dataLoaderWithDataLoader:(NSObject <XBDataLoader> *)dataLoader cache:(XBCache *)cache cacheKeyBuilder:(NSObject <XBCacheKeyBuilder> *)cacheKeyBuilder ttl:(NSTimeInterval)ttl {
    return [[self alloc] initWithDataLoader:dataLoader cache:cache cacheKeyBuilder:cacheKeyBuilder ttl:ttl];
}

- (id)initWithDataLoader:(NSObject <XBDataLoader> *)dataLoader cache:(XBCache *)cache cacheKeyBuilder:(NSObject<XBCacheKeyBuilder> *)cacheKeyBuilder ttl:(NSTimeInterval)ttl {
    self = [super init];
    if (self) {
        self.dataLoader = dataLoader;
        self.cache = cache;
        self.cacheKeyBuilder = cacheKeyBuilder;
        self.ttl = ttl;
    }

    return self;
}

- (NSString *)cacheKey {
    return [self.cacheKeyBuilder buildWithData:self.dataLoader];
}

- (void)loadDataWithSuccess:(void(^)(id))success failure:(void(^)(NSError *))failure
{
    BOOL canLoadFromNetwork = NO;
    if ([self.dataLoader conformsToProtocol:@protocol(XBHttpDataLoader)]) {
        canLoadFromNetwork = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable;
    }

    NSDictionary *cachedData = [self fetchDataFromCacheWithError:nil forceIfExpired:NO];
    if (!cachedData && canLoadFromNetwork) {
        [self.dataLoader loadDataWithSuccess:^(id loadedData) {
            NSError *error = nil;
            [self.cache setForKey:[self cacheKey] value:loadedData ttl:self.ttl error:&error];
            success(loadedData);
        } failure:^(NSError *error) {
            [self forceLoadDataFromCacheWithSuccess:success failure:failure httpError:error];
            failure(error);
        }];
    } else {
        if (cachedData) {
            success(cachedData);
            return;
        }
        [self forceLoadDataFromCacheWithSuccess:success failure:failure httpError:nil];
    }
}

- (void)forceLoadDataFromCacheWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure httpError:(NSError *)httpError {
    NSError *error;
    NSDictionary *cachedData = [self fetchDataFromCacheWithError:&error forceIfExpired:YES];
    if (cachedData) {
        success(cachedData);
    } else {
        failure(httpError ? httpError : error);
    }
}

- (NSDictionary *)fetchDataFromCacheWithError:(NSError **)error forceIfExpired:(BOOL)force {
    if (self.cache) {
        @try {
            return [self.cache getForKey:self.cacheKey error:error forceIfExpired:force];
        }
        @catch ( NSException *e ) {
            XBLogError( @"%@: %@", e.name, e.reason);
            [self.cache clearForKey:self.cacheKey error:nil];
        }
    }
    return nil;
}

@end