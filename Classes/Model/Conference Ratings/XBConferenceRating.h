//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    XBConferenceRatingValuePoor = 0,
    XBConferenceRatingValueFair = 1,
    XBConferenceRatingValueGood = 2,
    XBConferenceRatingValueVeryGood = 3,
    XBConferenceRatingValueExcellent = 4
} XBConferenceRatingValue;

@interface XBConferenceRating : NSObject<NSCoding>

@property (nonatomic, strong) NSDate *dateTaken;
@property (nonatomic, strong) NSString *conferenceId;
@property (nonatomic, strong) NSString *presentationId;
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSNumber *sent;

- (instancetype)initWithDateTaken:(NSDate *)dateTaken conferenceId:(NSString *)conferenceId presentationId:(NSString *)presentationId value:(XBConferenceRatingValue)value;
+ (instancetype)ratingWithDateTaken:(NSDate *)dateTaken conferenceId:(NSString *)conferenceId presentationId:(NSString *)presentationId value:(XBConferenceRatingValue)value;


@end