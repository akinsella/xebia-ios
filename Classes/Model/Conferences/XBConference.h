//
// Created by Simone Civetta on 25/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBDownloadableBundle.h"


@interface XBConference : NSObject<XBDownloadableBundle>

- (instancetype)initWithUid:(NSString *)uid;
+ (instancetype)conferenceWithUid:(NSString *)uid;

@end