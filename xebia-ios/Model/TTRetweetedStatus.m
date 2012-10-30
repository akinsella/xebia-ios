//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTTweet.h"
#import "Date.h"
#import "TTEntities.h"
#import "TTRetweetedStatus.h"


@implementation TTRetweetedStatus

    - (NSString *)dateFormatted {
        return [Date formattedDateRelativeToNow: self.created_at];
    }

    + (RKObjectMapping *)mapping {
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
            [mapping mapAttributes: @"text", @"created_at", nil];
            [mapping mapKeyPathsToAttributes:
                    @"id", @"identifier",
                    nil];

            // Relationships
            [mapping hasMany:@"user" withMapping:[TTUser mapping]];
        }];

        return mapping;
    }

@end