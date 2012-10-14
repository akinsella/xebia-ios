//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTEntity.h"


@implementation TTEntity

@synthesize text;
@synthesize indices;

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"text", @"indices", nil];
    }];

    return mapping;
}

@end