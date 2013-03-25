//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBBasicHttpHeaderBuilder.h"

@implementation XBBasicHttpHeaderBuilder

+ (id)builderWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }

    return self;
}

- (NSDictionary *)build {
    return self.dictionary;
}

@end
