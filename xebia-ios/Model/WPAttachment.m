//
//  WPAttachment.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPAttachment.h"
#import "DCParserConfiguration.h"

@implementation WPAttachment

+(DCKeyValueObjectMapping *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    return [DCKeyValueObjectMapping mapperForClass: [self class]  andConfiguration:config];
}

@end
