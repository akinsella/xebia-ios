//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBArrayDataSource.h"
#import "XBBundleArrayDataSourceConfiguration.h"

@interface XBBundleArrayDataSource : NSObject<XBArrayDataSource> {
    __weak Class _typeClass;
    NSString * _resourcePath;
    NSString * _resourceType;
    NSError *_error;
    NSString *_rootKeyPath;
}

@property (nonatomic, weak, readonly)Class typeClass;
@property (nonatomic, strong, readonly)NSString *resourcePath;
@property (nonatomic, strong, readonly)NSString *resourceType;
@property (nonatomic, strong, readonly)NSString *rootKeyPath;

+ (XBBundleArrayDataSource *)dataSourceWithConfiguration:(XBBundleArrayDataSourceConfiguration *)configuration;
- (id)initWithConfiguration:(XBBundleArrayDataSourceConfiguration *)configuration;

@end