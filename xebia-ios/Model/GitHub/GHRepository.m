//
//  GHRepository.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "GHRepository.h"
#import "GHOwner.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"

@implementation GHRepository

- (NSString *)description_ {
    return [NSString stringWithFormat:@"Language: %@ -  %@ Forks - %@ Watchers - %@ issues", self.language, self.forks, self.watchers, self.open_issues];
}

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return config;
}

@end

