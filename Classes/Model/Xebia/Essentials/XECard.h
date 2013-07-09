//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"

@class XECardCategory;
@class XECardFront;
@class XECardBack;

@interface XECard : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *sponsors;
@property (nonatomic, strong) XECardCategory *category;
@property (nonatomic, strong) XECardFront *front;
@property (nonatomic, strong) XECardBack *back;
@property (nonatomic, strong) NSURL *url;

@end