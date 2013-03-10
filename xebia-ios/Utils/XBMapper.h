//
// Created by akinsella on 19/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface XBMapper

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;

+ (NSArray *)parseData:(NSArray*)objectArray intoObjectsOfType:(Class)objectClass;

@end