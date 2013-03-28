//
// Created by akinsella on 25/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBCompositeArrayDataSource.h"
#import "XBCompositeArrayDataSource+protected.h"

@implementation XBCompositeArrayDataSource {
    NSObject<XBArrayDataSource> *_firstDataSource;
    NSObject<XBArrayDataSource> *_secondDataSource;
}

+ (id)dataSourceWithFirstDataSource:(NSObject<XBArrayDataSource> *)firstDataSource
                   secondDataSource:(NSObject<XBArrayDataSource> *)secondDataSource {
    return [[self alloc] initWithFirstDataSource:firstDataSource secondDataSource:secondDataSource];
}


- (NSObject<XBArrayDataSource> *)firstDataSource {
    return _firstDataSource;
}

- (NSObject<XBArrayDataSource> *)secondDataSource {
    return _secondDataSource;
}


- (id)initWithFirstDataSource:(NSObject<XBArrayDataSource> *)firstDataSource
             secondDataSource:(NSObject<XBArrayDataSource> *)secondDataSource {
    self = [super init];
    if (self) {
        _firstDataSource = firstDataSource;
        _secondDataSource = secondDataSource;
    }

    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [_secondDataSource objectAtIndexedSubscript:idx];
}

- (NSUInteger)count {
    return self.secondDataSource.count;
}

- (void)loadData {
    [self loadDataWithForceReload:NO callback: nil];
}

- (void)loadDataWithForceReload:(BOOL)force {
    [self loadDataWithForceReload:force callback: nil];
}

- (NSError *)error {
    return _firstDataSource.error ? _firstDataSource.error : _secondDataSource.error;
}

- (NSArray *)array {
    return _secondDataSource.array;
}

- (void)loadDataWithForceReload:(bool)force callback:(void(^)())callback {
    [_firstDataSource loadDataWithForceReload:force callback:^{
        if (_firstDataSource.error) {
           if (callback) {
               callback();
           }
        }
        else {
            [_secondDataSource loadDataWithForceReload:force callback:callback];
        }
    }];
}

@end