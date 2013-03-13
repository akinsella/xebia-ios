//
// Created by akinsella on 19/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "XBMappingProvider.h"

@interface XBMapper

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;

+ (NSArray *)parseArray:(NSArray*)objectArray intoObjectsOfType:(Class)objectClass;
+ (NSObject *)parseObject:(NSDictionary*)objectDictionnary intoObjectsOfType:(Class)objectClass;

@end