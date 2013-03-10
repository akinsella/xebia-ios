//
// Created by akinsella on 10/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface XBObjectDataSource : NSObject {
NSDictionary * _dataSource;
NSArray * _dataObject;
Class _typeClass;
}

@property (nonatomic, strong, readonly) id object;

- (id)initWithJson:(id)json ForType:(Class) typeClass;
+ (id)initWithJson:(id)json ForType:(Class) typeClass;
+ (id)initFromFileWithStorageFileName:(NSString *)storageFileName forType:(Class)typeClass;

- (NSDate *)lastUpdate;

@end