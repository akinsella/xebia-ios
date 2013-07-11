//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"

@class XECategory;

@interface XECard : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *sponsors;
@property (nonatomic, strong) XECategory *category;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSURL *url;

@end