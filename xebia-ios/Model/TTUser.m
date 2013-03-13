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

+ (DCKeyValueObjectMapping *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return [DCKeyValueObjectMapping mapperForClass: [self class] andConfiguration:config];
}

@end

