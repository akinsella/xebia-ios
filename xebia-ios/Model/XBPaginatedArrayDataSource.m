//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBArrayDataSource.h"
#import "XBMapper.h"
#import "JSONKit.h"
#import "NSDateFormatter+XBAdditions.h"
#import "XBPaginatedArrayDataSource.h"

@implementation XBPaginatedArrayDataSource {
    NSDictionary * _dataSource;
    NSArray * _dataArray;
    Class _typeClass;
    NSDateFormatter *_df;
}

- (NSDictionary *)data {
    return _dataSource[@"data"];
}

- (NSArray *)array {
    return _dataArray;
}

- (NSInteger)page {
    return [_dataSource[@"data"][@"page"] integerValue];
}

- (NSInteger)count {
    return [_dataSource[@"data"][@"count"] integerValue];
}

- (NSInteger)total {
    return [_dataSource[@"data"][@"total"] integerValue];
}

- (NSDate *)lastUpdate {
    return _dataSource[@"lastUpdate"];
}

- (id)initWithJson:(id)json ForType:(Class)typeClass {
    self = [super init];
    if (self) {
        _df = [NSDateFormatter initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
        _dataSource = json;
        _typeClass = typeClass;
        _dataArray = [XBMapper parseArray:self.data[@"data"] intoObjectsOfType:typeClass];
    }

    return self;
}

+ (id)initWithJson:(id)json ForType:(Class)typeClass {
    return [[XBPaginatedArrayDataSource alloc] initWithJson:json ForType:typeClass];
}

+ (id)initFromFileWithStorageFileName:(NSString *)storageFileName forType:(Class)typeClass {

    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:storageFileName];
    NSLog(@"Json cache file path: %@", filePath);

    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *json = [fileContent objectFromJSONString];

    return [XBPaginatedArrayDataSource initWithJson:json ForType:typeClass];
}

@end