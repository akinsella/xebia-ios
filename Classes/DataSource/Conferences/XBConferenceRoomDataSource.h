//
//  XBConferenceRoomDataSource.h
//  Xebia
//
//  Created by Simone Civetta on 29/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBReloadableArrayDataSource.h"

@interface XBConferenceRoomDataSource : XBReloadableArrayDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath;
+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath;

- (NSDictionary *)dictionaryWithRoomsAndBeacons;

@end
