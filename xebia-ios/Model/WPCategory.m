//
//  WPCategory.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WPCategory.h"

@implementation WPCategory

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
