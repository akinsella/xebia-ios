//
// Created by akinsella on 19/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <objc/runtime.h>

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
                id subObj = [self dictionaryWithPropertiesOfObject:value];
                [dict setObject:subObj forKey:key];
            }
            else if ([value isKindOfClass:NSArray.class]) {
                NSSet *array = (NSSet *)value;
                NSMutableArray *entries = [NSMutableArray arrayWithCapacity:[array count]];
                for (id entry in array) {
                    id subObj = [self dictionaryWithPropertiesOfObject:entry];
                    [entries addObject:subObj];
                }

                [dict setObject:entries forKey:key];
            }
            else if ([value isKindOfClass:NSSet.class]) {
                NSSet *set = (NSSet *)value;
                NSMutableArray *entries = [NSMutableArray arrayWithCapacity:[set count]];
                for (id entry in set) {
                    id subObj = [self dictionaryWithPropertiesOfObject:entry];
                    [entries addObject:subObj];
                }

                [dict setObject:entries forKey:key];
            }
            else if ([value isKindOfClass:NSObject.class]) {
                id subObj = [self dictionaryWithPropertiesOfObject:value];
                [dict setObject:subObj forKey:key];
            }
            else {
                [dict setObject:value forKey:key];
            }
        }
    }

    free(properties);

    return [NSDictionary dictionaryWithDictionary:dict];
}

@end