//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


@interface XBConferenceSpeakerTalk : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSString *presentationId;
@property (nonatomic, strong) NSString *presentationUri;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *title;

@end