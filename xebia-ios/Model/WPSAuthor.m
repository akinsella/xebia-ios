//
//  WPAuthor.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPSAuthor.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration.h"

@implementation WPSAuthor

+(DCKeyValueObjectMapping *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    return [DCKeyValueObjectMapping mapperForClass: [self class]  andConfiguration:config];
}

@end

