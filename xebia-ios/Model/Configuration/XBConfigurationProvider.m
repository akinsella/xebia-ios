//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBConfigurationProvider.h"
#import "XBHttpClient.h"
#import "XBConfiguration.h"


@implementation XBConfigurationProvider {
    XBConfiguration * _configuration;
    XBHttpClient * _httpClient;
}

+ (id)configurationProviderWithConfiguration:(XBConfiguration *)configuration {
    return [[XBConfigurationProvider alloc] initWithConfiguration:configuration];
}

- (id)initWithConfiguration:(XBConfiguration *)configuration {
    self = [super init];

    if (self) {
        _configuration = configuration;
        _httpClient = [XBHttpClient initWithBaseUrl:_configuration.baseUrl];
    }

    return self;
}

-(XBHttpClient *)httpClient {
    return _httpClient;
}

@end