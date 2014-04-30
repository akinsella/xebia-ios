//
//  XBConferencePresentationSlotDataSource.h
//  Xebia
//
//  Created by Simone Civetta on 30/04/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBReloadableArrayDataSource.h"

@interface XBConferencePresentationSlotDataSource : XBReloadableArrayDataSource

@property (nonatomic, strong) NSDate *day;

- (instancetype)initWithResourcePath:(NSString *)resourcePath;

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath;

@end
