//
// Created by Simone Civetta on 04/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <DCKeyValueObjectMapping/DCObjectMapping.h>
#import <DCKeyValueObjectMapping/DCCustomParser.h>
#import <DCKeyValueObjectMapping/DCArrayMapping.h>
#import <Underscore.m/Underscore.h>
#import "XBConferencePresentation.h"
#import "XBConferenceSpeaker.h"
#import "DCParserConfiguration+XBAdditions.h"
#import "DCCustomParser+XBConferenceAdditions.h"

NSString * const XBConferenceKindRegistration = @"Registration";
NSString * const XBConferenceKindBreak = @"Break";
NSString * const XBConferenceKindBreakfast = @"Breakfast";
NSString * const XBConferenceKindCoffeeBreak = @"Coffee Break";
NSString * const XBConferenceKindLunch = @"Lunch";

@interface XBConferencePresentation()

@property (nonatomic, strong) NSString *speakerString;

@end

@implementation XBConferencePresentation

+ (DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    [config addCustomParsersObject:[[DCCustomParser alloc] initWithBlockParser:[DCCustomParser stringParser]
                                                              forAttributeName:@"_identifier"
                                                            onDestinationClass:[self class]]];

    [config addCustomParsersObject:[[DCCustomParser alloc] initWithBlockParser:[DCCustomParser stringParser]
                                                              forAttributeName:@"_scheduleId"
                                                            onDestinationClass:[self class]]];

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"presentation.id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"scheduleId" onClass:[self class]]];

    DCCustomParser *fromTimeDateParser = [[DCCustomParser alloc] initWithBlockParser:[DCCustomParser dateTimeParser]
                                                            forAttributeName:@"_fromTime"
                                                          onDestinationClass:[self class]];
    [config addCustomParsersObject:fromTimeDateParser];

    DCCustomParser *toTimeDateParser = [[DCCustomParser alloc] initWithBlockParser:[DCCustomParser dateTimeParser]
                                                            forAttributeName:@"_toTime"
                                                          onDestinationClass:[self class]];
    
    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[XBConferenceSpeaker class] forAttribute:@"speakers" onClass:[self class]]];
    [config mergeConfig:[[XBConferenceSpeaker class] mappings]];
    
    [config addCustomParsersObject:toTimeDateParser];

    return config;
}

- (NSString *)speakerString {
    if (!_speakerString) {
        _speakerString = [Underscore.array(self.speakers).uniq.map(^(XBConferenceSpeaker *speaker){
            return speaker.name;
        }).unwrap componentsJoinedByString:@", "];
    }
    return _speakerString;
}

- (NSString *)presentationIdentifier {
    return self.identifier ? self.identifier : self.scheduleId;
}

- (BOOL)isAuxiliary {
    return [self.kind isEqualToString:XBConferenceKindBreak]
            || [self.kind isEqualToString:XBConferenceKindRegistration]
            || [self.kind isEqualToString:XBConferenceKindLunch]
            || [self.kind isEqualToString:XBConferenceKindCoffeeBreak]
            || [self.kind isEqualToString:XBConferenceKindBreakfast]
            ;
}

@end