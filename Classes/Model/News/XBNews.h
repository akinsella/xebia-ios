//
// Created by Alexis Kinsella on 23/10/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


@interface XBNews : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSDate *createdAt;
@property (nonatomic, assign) BOOL draft;
@property (nonatomic, assign) NSString *imageUrl;
@property (nonatomic, strong) NSDate *lastModified;
@property (nonatomic, strong) NSDate *publicationDate;
@property (nonatomic, strong) NSString *targetUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *typeId;

@end