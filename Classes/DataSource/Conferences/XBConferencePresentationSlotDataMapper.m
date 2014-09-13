//
//  XBConferencePresentationSlotDataMapper.m
//  Xebia
//
//  Created by Simone Civetta on 30/04/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferencePresentationSlotDataMapper.h"
#import "XBConferencePresentationSlot.h"
#import "XBConferencePresentation.h"
#import "NSDate+XBAdditions.h"

@implementation XBConferencePresentationSlotDataMapper

- (id)mapData:(id)data {
    NSArray *array = [super mapData:data];
    
    NSMutableDictionary *slots = [NSMutableDictionary dictionary];
    
    for (XBConferencePresentation *presentation in array) {
        if ([presentation.fromTime equalsToDayInDate:self.day]) {

            XBConferencePresentationSlot *slot = [XBConferencePresentationSlot new];
            slot.fromTime = presentation.fromTime;
            slot.toTime = presentation.toTime;
            
            if (![[slots allKeys] containsObject:slot]) {
                slots[slot] = slot;
            }
            [slots[slot] addPresentation:presentation];
        }
    }
    
    return [[slots allValues] sortedArrayUsingComparator:^NSComparisonResult(XBConferencePresentationSlot *slotA, XBConferencePresentationSlot *slotB) {
        return [slotA.fromTime compare:slotB.fromTime];
    }];
}

@end
