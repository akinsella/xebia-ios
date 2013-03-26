//
// Created by akinsella on 26/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBFileSystemCache.h"


@implementation XBFileSystemCache

+ (id)cacheWithDirectory:(NSString *)directory {
    return [[self alloc] initWithDirectory:directory];
}

- (id)initWithDirectory:(NSString *)directory {
    self = [super init];
    if (self) {
        _directory = directory;
    }

    return self;
}

- (void)setForKey:(NSString *)key value:(NSString *)value error:(NSError**)error {
    NSString *filePath = [self.directory stringByAppendingPathComponent:[self pathForKey:key]];
    NSLog(@"Set cache data at file path: %@", filePath);

    [value writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error: error];
}

- (NSString *)getForKey:(NSString *)key error:(NSError**)error {
    NSString *filePath = [self.directory stringByAppendingPathComponent:[self pathForKey:key]];
    NSLog(@"Get cache data at file path: %@", filePath);

    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:error];

    return fileContent;
}

- (void) clearForKey:(NSString *)key error:(NSError**)error {
    NSString *filePath = [self.directory stringByAppendingPathComponent:[self pathForKey:key]];
    NSLog(@"Clear cache data at file path: %@", filePath);

    [[NSFileManager defaultManager] removeItemAtPath:filePath error:error];
}

- (NSString *)pathForKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@.data", key];
}

@end