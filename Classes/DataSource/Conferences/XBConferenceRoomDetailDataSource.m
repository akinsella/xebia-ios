//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRoomDetailDataSource.h"
#import "XBConferenceTrack.h"
#import "XBLocalJsonDataLoader.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferencePresentation.h"
#import "XBJsonToArrayDataMapper.h"

@interface XBConferenceRoomDetailDataSource()

@property (nonatomic, strong) NSString *trackName;

@end

@implementation XBConferenceRoomDetailDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath roomName:(NSString *)roomName
{
    self = [super init];
    if (self) {
        self.dataLoader = [XBLocalJsonDataLoader dataLoaderWithResourcePath:resourcePath];
        self.trackName = roomName;
        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConferencePresentation class]];
        [self filter:^BOOL(XBConferencePresentation *presentation) {
            return [presentation.room isEqualToString:roomName];
        }];
    }

    return self;
}

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath roomName:(NSString *)roomName
{
    return [[self alloc] initWithResourcePath:resourcePath roomName:roomName];
}

@end