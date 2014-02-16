//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBReloadableArrayDataSource.h"


@interface XBConferenceTrackDetailDataSource : XBReloadableArrayDataSource
- (instancetype)initWithResourcePath:(NSString *)resourcePath trackName:(NSString *)trackName;
+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath trackName:(NSString *)trackName;
@end