//
//  WPTag.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPTag.h"

@implementation WPTag

@synthesize identifier;
@synthesize slug;
@synthesize description_;
@synthesize title;
@synthesize post_count;

- (NSString *)capitalizedTitle {
    return self.title;//[self.title stringByReplacingCharactersInRange:NSMakeRange(0,1)
           //                                   withString:[[self.title substringToIndex:1] capitalizedString]];
}

- (NSInteger)postCount {
    return [self.post_count integerValue];
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        mapping.rootKeyPath = @"tags";
        [mapping mapAttributes:@"slug", @"title", @"post_count", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                @"description", @"description_",
                nil];

    }];

    return mapping;
}

@end
