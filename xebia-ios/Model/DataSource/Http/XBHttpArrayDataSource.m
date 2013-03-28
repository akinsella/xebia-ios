//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBHttpArrayDataSource+protected.h"
#import "XBMapper.h"
#import "JSONKit.h"

@implementation XBHttpArrayDataSource {
    NSDictionary *_dataSource;
    NSArray *_dataArray;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return _dataArray[idx];
}
- (NSUInteger)count {
    return _dataArray.count;
}

- (NSArray *)data {
    return _dataSource[@"data"];
}

- (id)rawData {
    return _dataSource[@"data"];
}

- (NSError *)error {
    return _error;
}

- (NSArray *)array {
    return _dataArray;
}

- (NSString *)storageFileName {
    return [NSString stringWithFormat:@"%@", _storageFileName];
}

- (NSDate *)lastUpdate {
    return [self.dateFormat dateFromString:_dataSource[@"lastUpdate"]];
}

+ (XBHttpArrayDataSource *)dataSourceWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient {
    return [[self alloc] initWithConfiguration:configuration httpClient: httpClient];
}

- (id)initWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient {
    self = [super init];
    if (self) {
        _dateFormat = configuration.dateFormat;
        _typeClass = configuration.typeClass;
        _storageFileName = configuration.storageFileName;
        _maxDataAgeInSecondsBeforeServerFetch = configuration.maxDataAgeInSecondsBeforeServerFetch;
        _resourcePath = configuration.resourcePath;
        _rootKeyPath = configuration.rootKeyPath;
        _httpClient = httpClient;
        _httpQueryParamBuilder = configuration.httpQueryParamBuilder;
        _cache = configuration.cache;
    }

    return self;
}

- (void)loadData {
    [self loadDataWithForceReload:NO callback: nil];
}

- (void)loadDataWithForceReload:(BOOL)force {
    [self loadDataWithForceReload:force callback: nil];
}

- (void)loadDataWithForceReload:(bool)force callback:(void(^)())callback {

    _error = nil;

    [self fetchDataFromDB];

    NSTimeInterval repositoryDataAge = [self dataAgeFromFetchInfo];
    BOOL needUpdateFromServer = repositoryDataAge > _maxDataAgeInSecondsBeforeServerFetch;

    NSLog(@"Data age: %f seconds", repositoryDataAge);

    if (needUpdateFromServer) {
        NSLog(@"Data last update from server was %f seconds ago, forcing update from server", repositoryDataAge);
    }

    if (!needUpdateFromServer && !force && (_dataArray && _dataArray.count > 0) ) {
        if (callback) {
            callback();
        }
    }
    else {
        [self fetchDataFromServerWithCallback:callback];
    }
}

- (NSTimeInterval)dataAgeFromFetchInfo {
    return [self lastUpdate] ? [[self lastUpdate] timeIntervalSinceNow] : DBL_MAX;
}

- (void)fetchDataFromDB {
    if (_cache) {
        @try {
            NSError *error = nil;
            NSString *cacheData = [_cache getForKey:[self storageFileName] error: &error];
            if (cacheData) {
                NSDictionary *json = [cacheData objectFromJSONString];
                [self loadArrayFromJson:json];
            }
        }
        @catch ( NSException *e ) {
            NSLog( @"%@: %@", e.name, e.reason);
            NSError *error = nil;
            [_cache clearForKey:[self storageFileName] error:&error];
        }
    }
}

- (void)fetchDataFromServerWithCallback:(void (^)())callback {
    [self fetchDataFromServerInternalWithCallback:callback];
}

- (void)fetchDataFromServerInternalWithCallback:(void (^)())callback {
    [_httpClient executeGetJsonRequestWithPath:_resourcePath parameters:[_httpQueryParamBuilder build]
       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonFetched) {
           NSLog(@"jsonFetched: %@", jsonFetched);

           NSDictionary *json = @{
                   @"lastUpdate" : [_dateFormat stringFromDate:[NSDate date]],
                   @"data" : _rootKeyPath ? [jsonFetched valueForKeyPath:_rootKeyPath] : jsonFetched
           };

           if (_cache) {
               NSError *error;
               [_cache setForKey:[self storageFileName] value:[json JSONString] error:&error];
           }

           [self loadArrayFromJson:json];

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

- (void)loadArrayFromJson:(NSDictionary *)json {
    _dataSource = json;
    _dataArray = [XBMapper parseArray:self.data intoObjectsOfType:_typeClass];
}

@end