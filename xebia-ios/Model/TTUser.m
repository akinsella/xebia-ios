//
//  TTUser.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "TTUser.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation TTUser

- (NSURL *)avatarImageUrl {
    return [NSURL URLWithString:[self profile_image_url]];
}

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    return config;
}

@end

