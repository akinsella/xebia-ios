//
// Created by akinsella on 26/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBArrayDataSource.h"
#import "XBPagedArrayDataSource.h"

@interface XBPagedCompositeArrayDataSource : NSObject<XBPagedArrayDataSource> {
    NSObject<XBArrayDataSource> *_firstDataSource;
    NSObject<XBPagedArrayDataSource> *_secondDataSource;
}

@property(nonatomic, strong) NSObject<XBArrayDataSource> *firstDataSource;
@property(nonatomic, strong) NSObject<XBPagedArrayDataSource> *secondDataSource;

- (id)initWithFirstDataSource:(NSObject<XBArrayDataSource> *)firstDataSource
             secondDataSource:(NSObject<XBPagedArrayDataSource> *)secondDataSource;

+ (XBPagedCompositeArrayDataSource *)dataSourceWithFirstDataSource:(NSObject<XBArrayDataSource> *)firstDataSource
                   secondDataSource:(NSObject<XBPagedArrayDataSource> *)secondDataSource;

@end