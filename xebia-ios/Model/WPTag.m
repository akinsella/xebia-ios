//
//  WPTag.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WPTag.h"

@implementation WPTag

@dynamic identifier;
@dynamic slug;
@dynamic description_;
@dynamic title;
@dynamic post_count;

- (NSString *)capitalizedTitle {
    return [self.title stringByReplacingCharactersInRange:NSMakeRange(0,1)  
                                              withString:[[self.title substringToIndex:1] capitalizedString]];
}

- (NSInteger)postCount {
    return [self.post_count integerValue];
}

@end
