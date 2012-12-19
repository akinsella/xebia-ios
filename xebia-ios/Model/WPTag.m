//
//  WPTag.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPTag.h"

@implementation WPTag

- (NSString *)capitalizedTitle {
    return [self.title stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[self.title substringToIndex:1] capitalizedString]];
}

/*
- (NSInteger)postCount {
    return [self.post_count integerValue];
}
*/

@end
