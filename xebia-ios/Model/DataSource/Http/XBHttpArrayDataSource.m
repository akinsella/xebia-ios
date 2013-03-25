//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBHttpArrayDataSource+protected.h"
#import "XBMapper.h"
#import "JSONKit.h"
#import "XBBasicHttpHeaderBuilder.h"

@implementation XBHttpArrayDataSource {
    NSDictionary *_dataSource;
    NSArray *_dataArray;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}
- (NSUInteger)count {
    return _dataArray.count;
}

- (NSArray *)data {
    return _dataSource[@"data"];
}

- (NSError *)error {
    return _error;
}

- (NSArray *)array {
    return _dataArray;
}


- (NSDate *)lastUpdate {
    return [self.dateFormat dateFromString:_dataSource[@"lastUpdate"]];
}

+ (id)dataSourceWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient {
    return [[XBHttpArrayDataSource alloc] initWithConfiguration:configuration httpClient: httpClient];
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
        _httpHeaderBuilder = configuration.httpHeaderBuilder;
    }

    return self;
}

- (id)objectAtIndex:(NSUInteger)index {
    return _dataArray[index];
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
        [self fetchDataFromServerWitCallback: callback];
    }
}

- (NSTimeInterval)dataAgeFromFetchInfo {
    return [self lastUpdate] ? [[self lastUpdate] timeIntervalSinceNow] : DBL_MAX;
}

- (void)fetchDataFromDB {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:_storageFileName];
    NSLog(@"Json cache file path: %@", filePath);

    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *json = [fileContent objectFromJSONString];

    [self loadArrayFromJson:json];
}

- (void)fetchDataFromServerWitCallback:(void (^)())callback {

    [_httpClient executeGetJsonRequestWithPath:_resourcePath parameters: [_httpHeaderBuilder build]
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonFetched) {
            NSLog(@"jsonFetched: %@", jsonFetched);

            NSDictionary *json = @{
                @"lastUpdate": [_dateFormat stringFromDate:[NSDate date]],
                @"data": jsonFetched
            };

            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:_storageFileName];
            NSError *error;
            [[json JSONString] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error: &error];

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
    NSArray *array = _rootKeyPath ? [self.data valueForKeyPath:_rootKeyPath] : self.data;
    _dataArray = [XBMapper parseArray:array intoObjectsOfType:_typeClass];
}

@end