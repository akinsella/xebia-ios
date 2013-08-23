//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import "WPPostContentStructuredElement.h"
#import "WPPostContentStructuredElementAttribute.h"
#import "DCParserConfiguration+XBAdditions.h"


@implementation WPPostContentStructuredElement

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[WPPostContentStructuredElementAttribute class] forAttribute:@"attributes" onClass: [self class]]];
    [config mergeConfig:[[WPPostContentStructuredElementAttribute class] mappings]];

    return config;
}

- (id)objectForKeyedSubscript:(NSString *)key {

    for (WPPostContentStructuredElementAttribute * attribute in self.attributes) {
        if ([attribute.key isEqualToString: key]) {
            return attribute.value;
        }
    }
    return @"";
}
@end