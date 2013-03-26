//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBArrayDataSource.h"

@interface XBCompositeArrayDataSource : NSObject<XBArrayDataSource> {
    NSObject<XBArrayDataSource> *_firstDataSource;
    NSObject<XBArrayDataSource> *_secondDataSource;
}

@property(nonatomic, strong) NSObject<XBArrayDataSource> *firstDataSource;
@property(nonatomic, strong) NSObject<XBArrayDataSource> *secondDataSource;

- (id)initWithFirstDataSource:(NSObject<XBArrayDataSource> *)firstDataSource
             secondDataSource:(NSObject<XBArrayDataSource> *)secondDataSource;

+ (XBCompositeArrayDataSource *)dataSourceWithFirstDataSource:(NSObject<XBArrayDataSource> *)firstDataSource
                   secondDataSource:(NSObject<XBArrayDataSource> *)secondDataSource;

@end