//
// Created by Simone Civetta on 08/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBReloadableArrayDataSource.h"


@interface XBConferenceTrackDataSource : XBReloadableArrayDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath;
+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath;

@end