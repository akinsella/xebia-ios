//
// Created by akinsella on 01/11/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTUrlEntity.h"


@implementation TTUrlEntity

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"url", @"expanded_url", @"display_url", @"indices", nil];
    }];

    return mapping;
}

@end