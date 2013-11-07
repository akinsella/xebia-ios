//
// Created by Alexis Kinsella on 23/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"
#import "VMUser.h"

@interface VMVideo : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *embedPrivacy;
@property (nonatomic, assign) Boolean isHd;
@property (nonatomic, assign) Boolean isTranscoding;
@property (nonatomic, assign) Boolean isWatchLater;
@property (nonatomic, strong) NSString *privacy;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *uploadDate;
@property (nonatomic, strong) NSDate *modifiedDate;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *playCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) VMUser *owner;
@property (nonatomic, strong) NSArray *thumbnails;
@property (nonatomic, strong) NSArray *videoUrls;

@end