//
// Created by akinsella on 19/12/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSManagedObject+XBAdditions.h"
#import <objc/objc-runtime.h>

@implementation NSManagedObject (XBAdditions)


+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);

    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        Class classObject = NSClassFromString([key capitalizedString]);
        if (classObject) {
            id subObj = [self dictionaryWithPropertiesOfObject:[obj valueForKey:key]];
            [dict setObject:subObj forKey:key];
        }
        else
        {
            id value = [obj valueForKey:key];
            if(value) [dict setObject:value forKey:key];
        }
    }

    free(properties);

    return [NSDictionary dictionaryWithDictionary:dict];
}


@end