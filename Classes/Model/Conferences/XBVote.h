//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    XBVoteValueUndefined = 0,
    XBVoteValueNegative = 1,
    XBVoteValueNeuter = 2,
    XBVoteValuePositive = 3
} XBVoteValue;

@interface XBVote : NSObject

@property (nonatomic, strong) NSDate *dateTaken;
@property (nonatomic, strong) NSNumber *conferenceId;
@property (nonatomic, strong) NSNumber *presentationId;
@property (nonatomic, assign) XBVoteValue value;

- (instancetype)initWithDateTaken:(NSDate *)dateTaken conferenceId:(NSNumber *)conferenceId presentationId:(NSNumber *)presentationId value:(XBVoteValue)value;

+ (instancetype)voteWithDateTaken:(NSDate *)dateTaken conferenceId:(NSNumber *)conferenceId presentationId:(NSNumber *)presentationId value:(XBVoteValue)value;


@end