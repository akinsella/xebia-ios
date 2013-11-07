//
// Created by Alexis Kinsella on 07/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"

@interface VMVideoUrl :NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *bitrate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *codec;
@property (nonatomic, strong) NSString *type;

@end