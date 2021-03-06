//
// Created by Simone Civetta on 26/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceSpeakerDataSource.h"
#import "XBLocalJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferenceSpeaker.h"


@implementation XBConferenceSpeakerDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath {
    self = [super init];
    if (self) {
        self.dataLoader = [XBLocalJsonDataLoader dataLoaderWithResourcePath:resourcePath];
        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConferenceSpeaker class]];
        [self sort:^NSComparisonResult(XBConferenceSpeaker *speaker1, XBConferenceSpeaker *speaker2) {
            return [[speaker1.lastName lowercaseString] compare:[speaker2.lastName lowercaseString]];
        }];
    }

    return self;
}

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath {
    return [[self alloc] initWithResourcePath:resourcePath];
}

@end