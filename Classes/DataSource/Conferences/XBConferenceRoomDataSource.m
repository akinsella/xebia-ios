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
#import "XBArrayDataSource+protected.h"

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

- (NSDictionary *)dictionaryWithRoomsAndBeacons
{
    NSArray *allRooms = [self array];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (XBConferenceRoom *room in allRooms) {
        // TODO: Add a real room identifier
        dict[room.identifier] = @"00000000-0000-0000-0000-000000000000";
    }
    return dict;
}


@end
