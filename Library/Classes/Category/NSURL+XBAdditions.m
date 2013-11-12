//
// Created by akinsella on 01/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSURL+XBAdditions.h"


@implementation NSURL (XBAdditions)

- (NSString *)valueForParameterName:(NSString *)parameterName {
    NSArray * pairs = [self.query componentsSeparatedByString:@"&"];
    NSMutableDictionary * kvPairs = [NSMutableDictionary dictionary];
    for (NSString * pair in pairs) {
        NSArray * bits = [pair componentsSeparatedByString:@"="];
        NSString * key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [kvPairs setObject:value forKey:key];
    }

    return [kvPairs valueForKey:parameterName];
}

@end