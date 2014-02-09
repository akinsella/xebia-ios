//
// Created by Simone Civetta on 25/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConference.h"

@interface XBConference()
@property (nonatomic, strong) NSString *uid;
@end

@implementation XBConference

- (instancetype)initWithUid:(NSString *)uid {
    self = [super init];
    if (self) {
        self.uid = uid;
    }

    return self;
}

+ (instancetype)conferenceWithUid:(NSString *)uid {
    return [[self alloc] initWithUid:uid];
}

- (NSString *)uid {
    return _uid;
}

- (NSArray *)resources {
    return @[@"http://backend.mobile.xebia.io/api/v1/conferences/10/tracks",
            @"http://localhost:8082/experienceLevels.json",
            @"http://localhost:8082/presentations.json",
            @"http://localhost:8082/presentationTypes.json",
            @"http://localhost:8082/rooms.json",
            @"http://backend.mobile.xebia.io/api/v1/conferences/10/schedule",
            @"http://localhost:8082/speakers.json"
    ];
}

@end