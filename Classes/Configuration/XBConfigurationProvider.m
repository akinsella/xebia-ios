//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBConfigurationProvider.h"
#import "XBHttpClient.h"
#import "XBConstants.h"


@interface XBConfigurationProvider()

@property(nonatomic, strong)NSDictionary *dictionary;
@property(nonatomic, strong) XBHttpClient *httpClient;

@end

@implementation XBConfigurationProvider

+ (id)configurationProviderWithBaseUrl:(NSString *)baseUrl {
    return [XBConfigurationProvider configurationWithDictionnary:@{kXBBaseUrl: baseUrl }];
}

+(id)configurationWithDictionnary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionnary:dictionary];
}

-(id)initWithDictionnary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.httpClient = [XBHttpClient httpClientWithBaseUrl:self.baseUrl];
    }

    return self;
}

- (NSString *)baseUrl {
#if DEBUG
    return @"http://dev.xebia.fr:8000";
#else
    return self.dictionary[kXBBaseUrl];
#endif
}

@end