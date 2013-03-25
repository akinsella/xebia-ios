//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBConfiguration.h"


@implementation XBConfiguration {
    NSString *_baseUrl;
}

+ (id)initWithDictionary:(NSDictionary *)dictionary {
    return [[XBConfiguration alloc] initWithDictionnary:dictionary];
}

-(id)initWithDictionnary:(NSDictionary *)dictionnary {
    self = [super init];
    if (self) {
        _baseUrl = dictionnary[@"baseUrl"];
    }

    return self;
}

-(NSString *)baseUrl {
    return _baseUrl;
}

@end