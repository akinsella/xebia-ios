//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBArrayDataSource.h"
#import "XBMapper.h"
#import "JSONKit.h"
#import "NSDateFormatter+XBAdditions.h"

@implementation XBArrayDataSource {
    NSDateFormatter *_df;
}

- (NSArray *)data {
    return _dataSource[@"data"];
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
        _dataArray = [XBMapper parseData:self.data intoObjectsOfType:typeClass];
    }

    return self;
}

+ (id)initWithJson:(id)json ForType:(Class)typeClass {
    return [[XBArrayDataSource alloc] initWithJson:json ForType:typeClass];
}

+ (id)initFromFileWithStorageFileName:(NSString *)storageFileName forType:(Class)typeClass {

    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:storageFileName];
    NSLog(@"Json cache file path: %@", filePath);

    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *json = [fileContent objectFromJSONString];

    return [XBArrayDataSource initWithJson:json ForType:typeClass];
}

@end