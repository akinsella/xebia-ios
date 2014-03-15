//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBVote.h"


@implementation XBVote

- (instancetype)initWithDateTaken:(NSDate *)dateTaken conferenceId:(NSNumber *)conferenceId presentationId:(NSNumber *)presentationId value:(XBVoteValue)value {
    self = [super init];
    if (self) {
        self.dateTaken = dateTaken;
        self.conferenceId = conferenceId;
        self.presentationId = presentationId;
        self.value = value;
    }

    return self;
}

+ (instancetype)voteWithDateTaken:(NSDate *)dateTaken conferenceId:(NSNumber *)conferenceId presentationId:(NSNumber *)presentationId value:(XBVoteValue)value {
    return [[self alloc] initWithDateTaken:dateTaken conferenceId:conferenceId presentationId:presentationId value:value];
}


@end