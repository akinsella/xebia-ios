//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"

@class XECardFront;
@class XECardBack;

@interface XECardCategory : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *backgroundColor;

@end