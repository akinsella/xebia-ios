//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBHttpArrayDataSource.h"


@interface XBCompositeHttpArrayDataSource : NSObject<XBArrayDataSource> {
    XBHttpArrayDataSource *_firstDataSource;
    XBHttpArrayDataSource *_secondDataSource;
}

@property(nonatomic, strong) XBHttpArrayDataSource *firstDataSource;
@property(nonatomic, strong) XBHttpArrayDataSource *secondDataSource;

- (id)initWithFirstDataSource:(XBHttpArrayDataSource *)firstDataSource
             secondDataSource:(XBHttpArrayDataSource *)secondDataSource;

+ (id)dataSourceWithFirstDataSource:(XBHttpArrayDataSource *)firstDataSource
                   secondDataSource:(XBHttpArrayDataSource *)secondDataSource;

@end