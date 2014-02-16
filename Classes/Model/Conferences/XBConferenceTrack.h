//
// Created by Simone Civetta on 08/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


@interface XBConferenceTrack : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSNumber *conferenceId;
@property (nonatomic, strong) NSString *descriptionPlainText;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *name;

@end