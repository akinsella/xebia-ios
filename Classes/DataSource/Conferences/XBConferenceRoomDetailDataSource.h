//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBReloadableArrayDataSource.h"


@interface XBConferenceRoomDetailDataSource : XBReloadableArrayDataSource
- (instancetype)initWithResourcePath:(NSString *)resourcePath roomName:(NSString *)roomName;
+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath roomName:(NSString *)roomName;
@end