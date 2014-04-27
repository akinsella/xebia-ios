//
// Created by akinsella on 31/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBCacheElement.h"


@implementation XBCacheElement

+ (id)elementWithKey:(NSString *)key value:(NSObject *)value ttl:(NSTimeInterval)ttl {
    return [[self alloc] initWithKey:key value:value ttl:ttl];
}

- (id)initWithKey:(NSString *)key value:(NSObject *)value ttl:(NSTimeInterval)ttl {
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
        self.ttl = ttl;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _key   = [decoder decodeObjectForKey:@"key"];
        _value = [decoder decodeObjectForKey:@"value"];
        _ttl   = [decoder decodeDoubleForKey:@"ttl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)code
{
    [code encodeObject:_key forKey:@"key"];
    [code encodeObject:_value forKey:@"value"];
    [code encodeDouble:_ttl forKey:@"ttl"];
}

- (void)setTtl:(NSTimeInterval)ttl
{
    _ttl = [NSDate timeIntervalSinceReferenceDate] + ttl;
}

- (BOOL)hasExpired {
    if (!self.ttl) {
        return NO;
    }

    return ([NSDate timeIntervalSinceReferenceDate] > self.ttl);
}

@end