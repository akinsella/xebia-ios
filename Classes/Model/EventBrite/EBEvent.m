//
// Created by akinsella on 29/09/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "EBEvent.h"

@implementation EBEvent

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return config;
}

- (BOOL)isCompleted {
    return [self.status isEqualToString: @"Completed"];
}

@end