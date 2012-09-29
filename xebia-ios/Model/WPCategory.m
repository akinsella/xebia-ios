//
//  WPCategory.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPCategory.h"

@implementation WPCategory

@synthesize identifier;
@synthesize slug;
@synthesize description_;
@synthesize title;
@synthesize parent;
@synthesize post_count;

- (NSInteger)postCount {
    return [self.post_count integerValue];
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        mapping.rootKeyPath = @"categories";
        [mapping mapAttributes:@"slug", @"title", @"parent", @"post_count", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                @"description", @"description_",
                nil];
    }];

    return mapping;
}

@end
