//
// Created by akinsella on 26/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <JSONKit/JSONKit.h>
#import "XBPagedHttpArrayDataSource.h"
#import "XBHttpArrayDataSource+protected.h"

@implementation XBPagedHttpArrayDataSource

- (NSString *)storageFileName {
    return nil;
}

- (NSObject <XBPagedHttpQueryParamBuilder> *)httpPagedQueryParamBuilder {
    return (NSObject <XBPagedHttpQueryParamBuilder> *)_httpQueryParamBuilder;
}

+ (id)dataSourceWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient {
    return [[self alloc] initWithConfiguration:configuration httpClient: httpClient];
}

- (id)initWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient {

    if (![configuration.httpQueryParamBuilder conformsToProtocol:@protocol(XBPagedHttpQueryParamBuilder)]) {
        [NSException raise:NSInvalidArgumentException format:@"httpQueryParamBuilder does not conform to XBPagedHttpQueryParamBuilder protocol"];
    }

    if (configuration.cache) {
        [NSException raise:NSInvalidArgumentException format:@"XBPagedHttpArrayDataSource does not support cache"];
    }

    return [super initWithConfiguration:configuration httpClient:httpClient];
}

- (Boolean)hasMorePages {
    return self.httpPagedQueryParamBuilder.hasMorePages;
}

- (void)loadNextPageWithCallback:(void (^)())callback {
    if ([self.httpPagedQueryParamBuilder hasMorePages]) {
        [self fetchDataFromServerInternalWithCallback:callback merge:YES];
    }
    else if (callback) {
        callback();
    }
}

- (void)fetchDataFromServerWithCallback:(void (^)())callback {
    [self.httpPagedQueryParamBuilder resetPageIncrement];
    [self fetchDataFromServerInternalWithCallback:callback merge:NO];
}

- (void)fetchDataFromServerInternalWithCallback:(void (^)())callback merge:(Boolean)merge {

    [_httpClient executeGetJsonRequestWithPath:_resourcePath parameters: [_httpQueryParamBuilder build]
       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonFetched) {
           NSLog(@"jsonFetched: %@", jsonFetched);

           NSDictionary *json;
           if (!merge) {
               json = @{
                   @"lastUpdate": [_dateFormat stringFromDate:[NSDate date]],
                   @"data": _rootKeyPath ? [jsonFetched valueForKeyPath:_rootKeyPath] : jsonFetched
               };
           }
           else {
               NSMutableArray * mergedArray = [[self data] mutableCopy];

               [mergedArray addObjectsFromArray: (_rootKeyPath ? [jsonFetched valueForKeyPath:_rootKeyPath] : jsonFetched)];

               json = @{
                   @"lastUpdate": [_dateFormat stringFromDate:[NSDate date]],
                   @"data": mergedArray
               };
           }
           if (_cache) {
               NSError *error;
               [_cache setForKey:[self storageFileName] value:[json JSONString] error:&error];
           }

           [self loadArrayFromJson:json];

           [self.httpPagedQueryParamBuilder incrementPage];

           if (callback) {
               callback();
           }
       }
       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonFetched) {
           NSLog(@"Error: %@, jsonFetched: %@", error, jsonFetched);
           _error = error;
           if (callback) {
               callback();
           }
       }
    ];
}

@end
