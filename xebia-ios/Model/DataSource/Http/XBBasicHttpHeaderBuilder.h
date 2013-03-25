//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBHttpHeaderBuilder.h"


@interface XBBasicHttpHeaderBuilder : NSObject<XBHttpHeaderBuilder>

@property(nonatomic, strong)NSDictionary *dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (id)builderWithDictionary:(NSDictionary *)dictionary;

@end