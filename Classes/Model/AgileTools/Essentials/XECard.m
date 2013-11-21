//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "XECard.h"
#import "XECategory.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "XESponsor.h"
#import "XETag.h"
#import "XEULink.h"
#import "Underscore.h"


@implementation XECard

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"description" toAttribute:@"excerpt" onClass:[self class]]];
    
    [config mergeConfig:[XECategory mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XESponsor class] forAttribute:@"sponsors" onClass:[self class]]];
    [config mergeConfig:[[XESponsor class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XETag class] forAttribute:@"tags" onClass:[self class]]];
    [config mergeConfig:[[XETag class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XEULink class] forAttribute:@"ulinks" onClass:[self class]]];
    [config mergeConfig:[[XEULink class] mappings]];

    return config;
}

- (NSString *)identifierFormatted {
    NSArray *components = [self.identifier componentsSeparatedByString:@"-"];
    NSArray *capitalizedComponents = Underscore.array(components).map(^NSString *(NSString * component) {
        return [component stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                 withString:[[component  substringToIndex:1] capitalizedString]];
    }).unwrap;

    return [capitalizedComponents componentsJoinedByString:@" "];
}
@end