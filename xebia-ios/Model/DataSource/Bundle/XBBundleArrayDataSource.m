//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBBundleArrayDataSource.h"
#import "JSONKit.h"
#import "XBMapper.h"


@implementation XBBundleArrayDataSource {
    NSArray *_dataArray;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}
- (NSUInteger)count {
    return _dataArray.count;
}

- (NSError *)error {
    return _error;
}

- (NSArray *)array {
    return _dataArray;
}

+ (id)dataSourceWithConfiguration:(XBBundleArrayDataSourceConfiguration *)configuration {
    return [[XBBundleArrayDataSource alloc] initWithConfiguration:configuration];
}

- (id)initWithConfiguration:(XBBundleArrayDataSourceConfiguration *)configuration {
    self = [super init];
    if (self) {
        _typeClass = configuration.typeClass;
        _resourcePath = configuration.resourcePath;
        _resourceType = configuration.resourceType;
        _rootKeyPath = configuration.rootKeyPath;
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
    [self fetchDataFromBundleWithCallback:callback];
    }

- (void)fetchDataFromBundleWithCallback:(void (^)())callback {

    NSString *file = [[NSBundle mainBundle] pathForResource:_resourcePath ofType:_resourceType];
    NSError *error;
    NSString *jsonLoaded = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    NSDictionary *json = [jsonLoaded objectFromJSONString];
    _error = error;
    if (!error) {
        NSLog(@"jsonLoaded: %@", json);

        [self loadArrayFromJson:json];

    }
    if (callback) {
        callback();
    }
}

- (void)loadArrayFromJson:(NSDictionary *)json {
    NSArray *array = _rootKeyPath ? [json valueForKeyPath:_rootKeyPath] : json;
    _dataArray = [XBMapper parseArray:array intoObjectsOfType:_typeClass];
}

@end