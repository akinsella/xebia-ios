//
//  XBConferencePresentationSlotDataSource.m
//  Xebia
//
//  Created by Simone Civetta on 30/04/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferencePresentationSlotDataSource.h"
#import "XBLocalJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferencePresentation.h"
#import "NSDateFormatter+XBAdditions.h"
#import "NSDate+XBAdditions.h"
#import "XBConferencePresentationSlot.h"
#import "XBConferencePresentationSlotDataMapper.h"

@implementation XBConferencePresentationSlotDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath {
    self = [super init];
    if (self) {
        self.dataLoader = [XBLocalJsonDataLoader dataLoaderWithResourcePath:resourcePath];
        XBConferencePresentationSlotDataMapper *dataMapper = [XBConferencePresentationSlotDataMapper mapperWithRootKeyPath:nil typeClass:[XBConferencePresentation class]];
        dataMapper.day = self.day;
        self.dataMapper = dataMapper;
    }
    
    return self;
}

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath {
    return [[self alloc] initWithResourcePath:resourcePath];
}

- (void)setDay:(NSDate *)day {
    _day = day;
    XBConferencePresentationSlotDataMapper *dataMapper = (XBConferencePresentationSlotDataMapper *)self.dataMapper;
    dataMapper.day = day;
}

@end
