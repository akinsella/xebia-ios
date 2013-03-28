//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBConfiguration.h"


@implementation XBConfiguration


+ (id)configurationWithBaseUrl:(NSString *)baseUrl {
    return [[self alloc] initWithBaseUrl:baseUrl];
}

+ (id)initWithDictionary:(NSDictionary *)dictionary {
    return [[XBConfiguration alloc] initWithDictionnary:dictionary];
}

- (id)initWithBaseUrl:(NSString *)baseUrl {
    self = [super init];
    if (self) {
        _baseUrl = baseUrl;
    }

    return self;
}

-(id)initWithDictionnary:(NSDictionary *)dictionnary {
    self = [super init];
    if (self) {
        _baseUrl = dictionnary[@"baseUrl"];
    }

    return self;
}

@end