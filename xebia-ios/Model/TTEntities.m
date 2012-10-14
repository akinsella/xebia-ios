//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTEntities.h"
#import <RestKit/RestKit.h>
#import "TTEntity.h"

@implementation TTEntities

@synthesize hashtags;
@synthesize urls;
@synthesize user_mentions;

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {

        // Relationships
        [mapping mapKeyPath:@"hashtags" toRelationship:@"hashtags" withMapping:[TTEntity mapping]];
        [mapping mapKeyPath:@"urls" toRelationship:@"urls" withMapping:[TTEntity mapping]];
        [mapping mapKeyPath:@"user_mentions" toRelationship:@"user_mentions" withMapping:[TTEntity mapping]];
    }];

    return mapping;
}

@end