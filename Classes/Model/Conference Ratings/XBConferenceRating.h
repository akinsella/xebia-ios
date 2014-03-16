//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    XBConferenceRatingValueUndefined = 0,
    XBConferenceRatingValueNegative = 1,
    XBConferenceRatingValueNeuter = 2,
    XBConferenceRatingValuePositive = 3
} XBConferenceRatingValue;

@interface XBConferenceRating : NSObject

@property (nonatomic, strong) NSDate *dateTaken;
@property (nonatomic, strong) NSNumber *conferenceId;
@property (nonatomic, strong) NSNumber *presentationId;
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSNumber *sent;

- (instancetype)initWithDateTaken:(NSDate *)dateTaken conferenceId:(NSNumber *)conferenceId presentationId:(NSNumber *)presentationId value:(XBConferenceRatingValue)value;
+ (instancetype)ratingWithDateTaken:(NSDate *)dateTaken conferenceId:(NSNumber *)conferenceId presentationId:(NSNumber *)presentationId value:(XBConferenceRatingValue)value;


@end