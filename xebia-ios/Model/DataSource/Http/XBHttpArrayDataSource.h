//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "XBHttpClient.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "XBArrayDataSource.h"

@class XBBasicHttpHeaderBuilder;

@interface XBHttpArrayDataSource : NSObject<XBArrayDataSource> {
    __weak Class _typeClass;
    NSDateFormatter *_dateFormat;
    NSString * _storageFileName;
    NSInteger _maxDataAgeInSecondsBeforeServerFetch;
    NSString * _resourcePath;
    NSError *_error;
    NSString *_rootKeyPath;
    XBHttpClient *_httpClient;
    XBBasicHttpHeaderBuilder * httpHeaderBuilder;
}

@property (nonatomic, weak, readonly)Class typeClass;
@property (nonatomic, strong, readonly)NSDateFormatter *dateFormat;
@property (nonatomic, strong, readonly)NSString *storageFileName;
@property (nonatomic, assign, readonly)NSInteger maxDataAgeInSecondsBeforeServerFetch;
@property (nonatomic, strong, readonly)NSString *resourcePath;
@property (nonatomic, strong, readonly)NSString *rootKeyPath;
@property (nonatomic, assign, readonly)NSDate *lastUpdate;
@property (nonatomic, assign, readonly) XBBasicHttpHeaderBuilder * httpHeaderBuilder;

+ (id)dataSourceWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient;
- (id)initWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient;

@end