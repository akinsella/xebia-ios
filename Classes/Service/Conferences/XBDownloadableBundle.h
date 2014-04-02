//
// Created by Simone Civetta on 25/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XBDownloadableBundle <NSObject>

@required
- (NSString *)uid;
- (NSArray *)resources;

@end