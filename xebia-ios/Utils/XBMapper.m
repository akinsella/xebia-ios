//
// Created by akinsella on 19/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <objc/runtime.h>
#import "XBMapper.h"
#import "NSDateFormatter+XBAdditions.h"
#import "DCKeyValueObjectMapping.h"
#import "DCParserConfiguration.h"

@implementation XBMapper

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);

    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [obj valueForKey:key];

        if (value) {
            if ([value isKindOfClass:NSManagedObject.class]) {
                id subObj = [XBMapper dictionaryWithPropertiesOfObject:value];
                [dict setObject:subObj forKey:key];
            }
            else if ([value isKindOfClass:NSArray.class]) {
                NSSet *array = (NSSet *)value;
                NSMutableArray *entries = [NSMutableArray arrayWithCapacity:[array count]];
                for (id entry in array) {
                    id subObj = [XBMapper dictionaryWithPropertiesOfObject:entry];
                    [entries addObject:subObj];
                }

                [dict setObject:entries forKey:key];
            }
            else if ([value isKindOfClass:NSSet.class]) {
                NSSet *set = (NSSet *)value;
                NSMutableArray *entries = [NSMutableArray arrayWithCapacity:[set count]];
                for (id entry in set) {
                    id subObj = [XBMapper dictionaryWithPropertiesOfObject:entry];
                    [entries addObject:subObj];
                }

                [dict setObject:entries forKey:key];
            }
            else if ([value isKindOfClass:NSDate.class]) {
                [dict setObject:value forKey:[[NSDateFormatter initWithDateFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:value]];
            }
            else {
                Class classObject = NSClassFromString([key capitalizedString]);
                if (classObject) {
                    id subObj = [self dictionaryWithPropertiesOfObject:[obj valueForKey:key]];
                    [dict setObject:subObj forKey:key];
                }
                else {
                    if(value) {
                        [dict setObject:value forKey:key];
                    }
                }
            }
        }
    }

    free(properties);

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NSArray *)parseData:(NSArray*)objectArray intoObjectsOfType:(Class)objectClass {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"dd/MM/yyyy";

    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: objectClass andConfiguration: config];

    return [parser parseArray:objectArray];
}

@end