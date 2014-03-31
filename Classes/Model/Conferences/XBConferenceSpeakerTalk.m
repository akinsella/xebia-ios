//
// Created by Simone Civetta on 16/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import "XBConferenceSpeakerTalk.h"


@implementation XBConferenceSpeakerTalk {

}
+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    return config;
}

- (NSString *)standardIdentifier {
    return self.presentationId;
}

@end