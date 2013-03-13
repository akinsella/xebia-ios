//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface XBArrayDataSource : NSObject

- (NSArray *) array;

- (id) data;

- (id)initWithJson:(id)json ForType:(Class) typeClass;
+ (id)initWithJson:(id)json ForType:(Class) typeClass;
+ (id)initFromFileWithStorageFileName:(NSString *)storageFileName forType:(Class)typeClass;

- (NSDate *)lastUpdate;

@end