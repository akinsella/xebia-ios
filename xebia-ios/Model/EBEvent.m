//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBEvent.h"
#import "EBVenue.h"
#import "EBOrganizer.h"

@implementation EBEvent

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"text", @"type", @"capacity", @"title", @"start_date",
                        @"end_date", @"timezone_offset", @"tags",  @"created",  @"url",
                        @"privacy", @"status", @"description_plain_text", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                @"description", @"description_",
                nil];
    }];

    // Relationships
    [mapping hasMany:@"venue" withMapping:[EBVenue mapping]];
    [mapping hasMany:@"organizer" withMapping:[EBOrganizer mapping]];

    return mapping;
}

@end