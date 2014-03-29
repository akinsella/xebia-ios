//
// Created by Simone Civetta on 04/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceScheduleDataSource.h"
#import "XBLocalJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferencePresentation.h"
#import "NSDateFormatter+XBAdditions.h"
#import "NSDate+XBAdditions.h"


@implementation XBConferenceScheduleDataSource {

}

- (instancetype)initWithResourcePath:(NSString *)resourcePath {
    self = [super init];
    if (self) {
        self.dataLoader = [XBLocalJsonDataLoader dataLoaderWithResourcePath:resourcePath];
        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConferencePresentation class]];
    }

    return self;
}

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath {
    return [[self alloc] initWithResourcePath:resourcePath];
}

- (void)loadAndFilterDistinctDays:(void (^)())callback {
    [self loadDataWithCallback:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableDictionary *uniqueDays = [NSMutableDictionary dictionary];
            NSDateFormatter *formatter = [NSDateFormatter initWithDateFormat:@"YYYYMMdd"];
            [self filter:^BOOL(XBConferencePresentation *pres) {
                NSString *dateIdentifier = [formatter stringFromDate:pres.fromTime];
                if (!uniqueDays[dateIdentifier]) {
                    uniqueDays[dateIdentifier] = pres;
                    return YES;
                }
                return NO;
            }];
            
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            }
        });
    }];
}

- (void)loadAndFilterByDay:(NSDate *)day callback:(void (^)())callback {
    [self loadDataWithCallback:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self filter:^BOOL(XBConferencePresentation *pres) {
                return [pres.fromTime equalsToDayInDate:day];
            }];
            
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            }
        });
    }];
}

- (void)loadAndFilterByIdentifiers:(NSArray *)identifiers callback:(void (^)())callback {
    [self loadDataWithCallback:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self filter:^BOOL(XBConferencePresentation *pres) {
                return [identifiers containsObject:pres.identifier];
            }];
            
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            }
        });
    }];
}

@end