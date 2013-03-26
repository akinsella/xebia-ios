//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "XBHttpClient.h"
#import "XBHttpArrayDataSourceConfiguration.h"
#import "XBArrayDataSource.h"
#import "XBBasicHttpQueryParamBuilder.h"

@interface XBHttpArrayDataSource : NSObject<XBArrayDataSource> {
    __weak Class _typeClass;
    NSDateFormatter *_dateFormat;

    NSInteger _maxDataAgeInSecondsBeforeServerFetch;
    NSString *_storageFileName;
    NSString * _resourcePath;
    NSError *_error;
    NSString *_rootKeyPath;
    XBHttpClient *_httpClient;
    __unsafe_unretained NSObject<XBHttpQueryParamBuilder> *_httpQueryParamBuilder;
    NSObject<XBCache> *_cache;

}

@property (nonatomic, weak, readonly)Class typeClass;
@property (nonatomic, strong, readonly)NSDateFormatter *dateFormat;
@property (nonatomic, assign, readonly)NSInteger maxDataAgeInSecondsBeforeServerFetch;
@property (nonatomic, strong, readonly)NSString *resourcePath;
@property (nonatomic, strong, readonly)NSString *rootKeyPath;
@property (nonatomic, assign, readonly)NSDate *lastUpdate;
@property (nonatomic, assign, readonly)NSObject<XBHttpQueryParamBuilder> *httpQueryParamBuilder;

+ (XBHttpArrayDataSource *)dataSourceWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient;
- (id)initWithConfiguration:(XBHttpArrayDataSourceConfiguration *)configuration httpClient:(XBHttpClient *)httpClient;

@end