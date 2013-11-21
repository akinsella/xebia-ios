//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBConfigurationProvider.h"
#import "XBConstants.h"


@interface XBConfigurationProvider()

@property(nonatomic, strong) NSDictionary *dictionary;
@property(nonatomic, strong) XBHttpClient *httpClient;
@property(nonatomic, strong) Reachability *reachability;

@end

@implementation XBConfigurationProvider

+ (id)configurationProviderWithBaseUrl:(NSString *)baseUrl {
    return [XBConfigurationProvider configurationWithDictionary:@{kXBBaseUrl : baseUrl}];
}

+(id)configurationWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.httpClient = [XBHttpClient httpClientWithBaseUrl:self.baseUrl];
        NSURL *url = [NSURL URLWithString:self.baseUrl];

        self.reachability = [Reachability reachabilityWithHostname:url.host];
    }

    return self;
}


- (NSString *)baseUrl {
//#if DEBUG
//    return @"http://dev.xebia.fr:8000";
//#else
    return self.dictionary[kXBBaseUrl];
//#endif
}

@end