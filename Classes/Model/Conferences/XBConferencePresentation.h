//
// Created by Simone Civetta on 04/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


@interface XBConferencePresentation : NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *conferenceId;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *scheduleId;
@property (nonatomic, strong) NSDate *fromTime;
@property (nonatomic, strong) NSDate *toTime;
@property (nonatomic, assign) BOOL partnerSlot;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *speakers;
@property (nonatomic, strong) NSString *track;

- (NSString *)speakerString;

@end