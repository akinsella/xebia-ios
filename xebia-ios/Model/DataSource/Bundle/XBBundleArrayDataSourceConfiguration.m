//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBBundleArrayDataSourceConfiguration.h"

@implementation XBBundleArrayDataSourceConfiguration : NSObject


+ (XBBundleArrayDataSourceConfiguration *)configuration {
    XBBundleArrayDataSourceConfiguration *configuration = [[XBBundleArrayDataSourceConfiguration alloc] init];

    return configuration;
}

+ (XBBundleArrayDataSourceConfiguration *)configurationWithResourcePath:(NSString *)resourcePath
                                                           resourceType:(NSString *)resourceType
                                                              typeClass:(Class)typeClass
                                                            rootKeyPath:(NSString *)rootKeyPath {

    XBBundleArrayDataSourceConfiguration *configuration = [XBBundleArrayDataSourceConfiguration configuration];

    configuration.resourcePath = resourcePath;
    configuration.typeClass = typeClass;
    configuration.rootKeyPath = rootKeyPath;
    configuration.resourceType = resourceType;

    return configuration;
}

+ (XBBundleArrayDataSourceConfiguration *)configurationWithResourcePath:(NSString *)resourcePath
                                                           resourceType:(NSString *)resourceType
                                                              typeClass:(Class)typeClass {

    return [XBBundleArrayDataSourceConfiguration configurationWithResourcePath:resourcePath
                                                                  resourceType:resourceType
                                                                     typeClass:typeClass
                                                                   rootKeyPath:nil];
}

@end