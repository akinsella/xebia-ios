//
// Created by Alexis Kinsella on 09/07/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"

@interface XEDeck : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *cards;

@end