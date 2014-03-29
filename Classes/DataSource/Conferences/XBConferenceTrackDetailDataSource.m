//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceTrackDetailDataSource.h"
#import "XBConferenceTrack.h"
#import "XBLocalJsonDataLoader.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferencePresentation.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBArrayDataSource+protected.h"

@interface XBConferenceTrackDetailDataSource()

@property (nonatomic, strong) NSString *trackName;

@end

@implementation XBConferenceTrackDetailDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath trackName:(NSString *)trackName {
    self = [super init];
    if (self) {
        self.dataLoader = [XBLocalJsonDataLoader dataLoaderWithResourcePath:resourcePath];
        self.trackName = trackName;
        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConferencePresentation class]];
        [self setFilterPredicate:^BOOL(XBConferencePresentation *presentation) {
            return [presentation.track isEqualToString:trackName];
        }];
    }

    return self;
}

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath trackName:(NSString *)trackName {
    return [[self alloc] initWithResourcePath:resourcePath trackName:trackName];
}

@end