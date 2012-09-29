//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBVenue.h"

@implementation EBVenue

@synthesize identifier;
@synthesize city;
@synthesize name;
@synthesize region;
@synthesize postal_code;
@synthesize longitude;
@synthesize latitude;
@synthesize country_code;

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        [mapping mapAttributes: @"url", @"description", @"name", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                nil];
    }];

    return mapping;
}

@end