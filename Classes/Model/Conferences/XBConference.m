//
// Created by Simone Civetta on 25/01/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import "XBConference.h"
#import "DCCustomParser+XBConferenceAdditions.h"

@implementation XBConference

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }

    return self;
}

+ (instancetype)conferenceWithIdentifier:(NSString *)identifier {
    return [[self alloc] initWithIdentifier:identifier];
}

- (NSString *)uid {
    return _identifier;
}

- (NSArray *)resources {
    return @[
            [NSString stringWithFormat:@"http://backend.mobile.xebia.io/api/v1/conferences/%@/tracks", self.identifier],
            [NSString stringWithFormat:@"http://backend.mobile.xebia.io/api/v1/conferences/%@/rooms", self.identifier],
            [NSString stringWithFormat:@"http://backend.mobile.xebia.io/api/v1/conferences/%@/schedule", self.identifier],
            [NSString stringWithFormat:@"http://backend.mobile.xebia.io/api/v1/conferences/%@/presentations", self.identifier],
            [NSString stringWithFormat:@"http://backend.mobile.xebia.io/api/v1/conferences/%@/speakers", self.identifier]
    ];
}

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addCustomParsersObject:[[DCCustomParser alloc] initWithBlockParser:[DCCustomParser stringParser]
                                                              forAttributeName:@"_identifier"
                                                            onDestinationClass:[self class]]];

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

@end