//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBEvent.h"
#import "EBVenue.h"
#import "EBOrganizer.h"

@implementation EBEvent

@synthesize identifier;
@synthesize type;
@synthesize capacity;
@synthesize title;
@synthesize start_date;
@synthesize end_date;
@synthesize timezone_offset;
@synthesize tags;
@synthesize created;
@synthesize url;
@synthesize privacy;
@synthesize status;
@synthesize description_;
@synthesize description_plain_text;
@synthesize venue;
@synthesize organizer;

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