//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTTweet.h"
#import "Date.h"
#import "TTRetweetedStatus.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"


@implementation TTRetweetedStatus

- (NSString *)dateFormatted {
    return [Date formattedDateRelativeToNow: self.created_at];
}

+ (DCKeyValueObjectMapping *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return [DCKeyValueObjectMapping mapperForClass: [self class] andConfiguration:config];
}

@end