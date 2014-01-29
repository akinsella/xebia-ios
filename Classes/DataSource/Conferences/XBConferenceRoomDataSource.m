//
//  XBConferenceRoomDataSource.m
//  Xebia
//
//  Created by Simone Civetta on 29/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRoomDataSource.h"
#import "XBLocalJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferenceRoom.h"

@implementation XBConferenceRoomDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath {
    self = [super init];
    if (self) {
        self.dataLoader = [XBLocalJsonDataLoader dataLoaderWithResourcePath:resourcePath];
        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConferenceRoom class]];
    }
    
    return self;
}

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath {
    return [[self alloc] initWithResourcePath:resourcePath];
}


@end
