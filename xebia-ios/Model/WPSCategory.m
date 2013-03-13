//
//  WPCategory.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPSCategory.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation WPSCategory

+(DCKeyValueObjectMapping *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    return [DCKeyValueObjectMapping mapperForClass: [self class]  andConfiguration:config];
}

@end
