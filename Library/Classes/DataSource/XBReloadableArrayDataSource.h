//
// Created by akinsella on 29/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBArrayDataSource.h"
#import "XBDataLoader.h"
#import "XBDataMapper.h"

@protocol XBReloadableArrayDataSourceDelegate<NSObject>

@optional

-(void)onDataLoaded:(id)data;
-(void)onError:(NSError *)error;

@end

@interface XBReloadableArrayDataSource : XBArrayDataSource

@property (nonatomic, strong, readonly)NSError *error;
@property (nonatomic, strong, readonly)id rawData;
@property (nonatomic, strong, readonly)NSObject<XBDataLoader> *dataLoader;
@property (nonatomic, strong, readonly)NSObject<XBDataMapper> *dataMapper;
@property (nonatomic, weak)id<XBReloadableArrayDataSourceDelegate>delegate;

- (id)initWithDataLoader:(NSObject <XBDataLoader> *)dataLoader dataMapper:(NSObject <XBDataMapper> *)dataMapper;

+ (id)dataSourceWithDataLoader:(NSObject <XBDataLoader> *)dataLoader dataMapper:(NSObject <XBDataMapper> *)dataMapper;

- (void)loadData;

- (void)loadDataWithCallback:(void (^)())callback;

@end