//
//  XBConferencePresentationSlot.m
//  Xebia
//
//  Created by Simone Civetta on 30/04/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferencePresentationSlot.h"

@interface XBConferencePresentationSlot()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation XBConferencePresentationSlot

- (instancetype)init {
    if (self = [super init]) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![super isEqual:object]) {
        return [self isEqualToSlot:object];
    }
    return YES;
}

- (BOOL)isEqualToSlot:(XBConferencePresentationSlot *)slot {
    if (![slot isKindOfClass:[XBConferencePresentationSlot class]]) {
        return NO;
    }
    return [slot.fromTime isEqualToDate:self.fromTime] && [slot.toTime isEqualToDate:self.toTime];
}

- (id)copyWithZone:(NSZone *)zone {
    XBConferencePresentationSlot *copy = [XBConferencePresentationSlot new];

    copy.fromTime = self.fromTime;
    copy.toTime = self.toTime;

    return copy;
}

- (void)addPresentation:(id)presentation {
    [self.array addObject:presentation];
}

- (NSUInteger)count {
    return [self.array count];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.array[idx];
}

- (NSString *)dateFormatted {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    return [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:self.fromTime], [formatter stringFromDate:self.toTime]];
}

@end
