//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol XBArrayDataSource <NSObject>

@required
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)loadDataWithForceReload:(bool)force callback:(void(^)())callback;

- (void)loadDataWithForceReload:(BOOL)force;

- (void)loadData;

- (NSError *)error;

- (NSArray *)array;

- (NSUInteger)count;

@end