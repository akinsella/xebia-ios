//
//  XBConferencePresentationSlot.h
//  Xebia
//
//  Created by Simone Civetta on 30/04/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBConferencePresentationSlot : NSObject<NSCopying>

@property (nonatomic, strong) NSDate *fromTime;
@property (nonatomic, strong) NSDate *toTime;

- (void)addPresentation:(id)presentation;
- (NSUInteger)count;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSString *)dateFormatted;

@end
