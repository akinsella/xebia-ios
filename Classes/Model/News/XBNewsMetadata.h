//
// Created by Alexis Kinsella on 12/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


@interface XBNewsMetadata : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;

@end