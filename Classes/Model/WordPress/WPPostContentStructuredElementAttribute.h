//
// Created by Alexis Kinsella on 21/08/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


@interface WPPostContentStructuredElementAttribute : NSObject<XBMappingProvider>

@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString  *value;

@end