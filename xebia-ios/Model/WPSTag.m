//
//  WPTag.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPSTag.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation WPSTag

- (NSString *)capitalizedTitle {
    return [self.title stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[[self.title substringToIndex:1] capitalizedString]];
}

+(DCKeyValueObjectMapping *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    return [DCKeyValueObjectMapping mapperForClass: [self class]  andConfiguration:config];
}

@end
