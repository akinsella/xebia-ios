//
// Created by akinsella on 02/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBPListConfigurationProvider.h"

@implementation XBPListConfigurationProvider

+(id)provider {
    return [[self alloc] init];
}

- (id)init {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSDictionary *dictionary = [bundle infoDictionary];
    self = [super initWithDictionary:dictionary];
    if (self) {
        //
    }

    return self;
}

@end