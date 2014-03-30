//
// Created by Simone Civetta on 25/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import "XBConference.h"
#import "DCCustomParser+XBConferenceAdditions.h"

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
            @"http://backend.mobile.xebia.io/api/v1/conferences/10/rooms",
            @"http://backend.mobile.xebia.io/api/v1/conferences/10/schedule",
            @"http://backend.mobile.xebia.io/api/v1/conferences/10/presentations",
            @"http://backend.mobile.xebia.io/api/v1/conferences/10/speakers"
    ];
}

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];

    DCCustomParser *fromTimeDateParser = [[DCCustomParser alloc] initWithBlockParser:[DCCustomParser dateParser]
                                                                    forAttributeName:@"_from"
                                                                  onDestinationClass:[self class]];
    [config addCustomParsersObject:fromTimeDateParser];

    DCCustomParser *toTimeDateParser = [[DCCustomParser alloc] initWithBlockParser:[DCCustomParser dateParser]
                                                                  forAttributeName:@"_to"
                                                                onDestinationClass:[self class]];
    [config addCustomParsersObject:toTimeDateParser];

    return config;
}

- (NSString *)name
{
    //TODO: dynamyse these values
    return @"DUMMY DUMMY";
}

- (NSString *)imageURL
{
    //TODO: dynamyse these values
    return @"http://blogs-images.forbes.com/scottmendelson/files/2014/02/the_lego_movie_2014-wide.jpg";
}

- (NSString *)identifier
{
    //TODO: dynamyse these values
    return @"10";
}


@end