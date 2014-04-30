//
//  XBConferencePresentationSlotDataMapper.h
//  Xebia
//
//  Created by Simone Civetta on 30/04/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBJsonToArrayDataMapper.h"

@interface XBConferencePresentationSlotDataMapper : XBJsonToArrayDataMapper

@property (nonatomic, strong) NSDate *day;

@end
