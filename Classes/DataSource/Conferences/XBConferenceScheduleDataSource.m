//
// Created by Simone Civetta on 04/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceScheduleDataSource.h"
#import "XBLocalJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferencePresentation.h"


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

@end