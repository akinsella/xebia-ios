//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTEntities.h"
#import "TTEntity.h"
#import "TTHashtagEntity.h"
#import "TTUrlEntity.h"
#import "TTUserMentionEntity.h"

@implementation TTEntities

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {

        // Relationships
        [mapping mapKeyPath:@"hashtags" toRelationship:@"hashtags" withMapping:[TTHashtagEntity mapping]];
        [mapping mapKeyPath:@"urls" toRelationship:@"urls" withMapping:[TTUrlEntity mapping]];
        [mapping mapKeyPath:@"user_mentions" toRelationship:@"user_mentions" withMapping:[TTUserMentionEntity mapping]];
    }];

    return mapping;
}

@end