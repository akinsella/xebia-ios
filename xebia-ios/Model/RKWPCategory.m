//
//  RKWPCategory.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKWPCategory.h"

@implementation RKWPCategory

@dynamic identifier;
@dynamic slug;
@dynamic description_;
@dynamic title;
@dynamic parent;
@dynamic post_count;


- (NSInteger)postCount {
    return [self.post_count integerValue];
}

@end
