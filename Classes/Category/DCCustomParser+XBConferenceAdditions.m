//
// Created by Simone Civetta on 04/02/14.
//

#import "DCCustomParser.h"
#import "DCCustomParser+XBConferenceAdditions.h"
#import "NSDateFormatter+XBAdditions.h"


@implementation DCCustomParser (XBConferenceAdditions)

+ (DCCustomParserBlock)dateParser {
    DCCustomParserBlock block = ^(__weak NSDictionary *dictionary, __weak NSString *attributeName, __weak Class destinationClass, __weak id value) {
        NSDateFormatter *formatter = [NSDateFormatter initWithDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        return [formatter dateFromString:value];
    };
    return block;
}

@end
