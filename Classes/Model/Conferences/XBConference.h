//
// Created by Simone Civetta on 25/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBDownloadableBundle.h"
#import "XBMappingProvider.h"


@interface XBConference : NSObject<XBDownloadableBundle, XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSDate *from;
@property (nonatomic, strong) NSDate *to;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSNumber *enabled;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *backgroundUrl;
@property (nonatomic, strong) NSString *logoUrl;

- (instancetype)initWithIdentifier:(NSNumber *)identifier;
+ (instancetype)conferenceWithIdentifier:(NSNumber *)identifier;

@end
