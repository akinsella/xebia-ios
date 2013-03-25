//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBConfiguration.h"
#import "XBHttpClient.h"

@interface XBConfigurationProvider : NSObject

@property(nonatomic, strong, readonly)NSString *baseUrl;
@property(nonatomic, strong, readonly)XBHttpClient *httpClient;

+ (id)configurationProviderWithConfiguration:(XBConfiguration *)configuration;
- (id)initWithConfiguration:(XBConfiguration *)configuration;

@end