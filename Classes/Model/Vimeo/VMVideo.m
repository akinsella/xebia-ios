//
// Created by Alexis Kinsella on 23/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "VMVideo.h"
#import "VMVideoUrl.h"
#import "VMThumbnail.h"
#import "DCParserConfiguration+XBAdditions.h"


@implementation VMVideo

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config mergeConfig:[VMUser mappings]];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[VMThumbnail class] forAttribute:@"thumbnails" onClass:[self class]]];
    [config mergeConfig:[[VMThumbnail class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[VMVideoUrl class] forAttribute:@"videoUrls" onClass:[self class]]];
    [config mergeConfig:[[VMVideoUrl class] mappings]];

    return config;
}

@end