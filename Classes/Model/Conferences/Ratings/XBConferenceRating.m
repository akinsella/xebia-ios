//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRating.h"


@implementation XBConferenceRating

- (instancetype)initWithDateTaken:(NSDate *)dateTaken conferenceId:(NSNumber *)conferenceId presentationId:(NSString *)presentationId value:(XBConferenceRatingValue)value {
    self = [super init];
    if (self) {
        self.dateTaken = dateTaken;
        self.conferenceId = conferenceId;
        self.presentationId = presentationId;
        self.value = @(value);
    }

    return self;
}

+ (instancetype)ratingWithDateTaken:(NSDate *)dateTaken conferenceId:(NSNumber *)conferenceId presentationId:(NSString *)presentationId value:(XBConferenceRatingValue)value {
    return [[self alloc] initWithDateTaken:dateTaken conferenceId:conferenceId presentationId:presentationId value:value];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToRating:other];
}

- (BOOL)isEqualToRating:(XBConferenceRating *)aConferenceRating {
    if (self == aConferenceRating)
        return YES;
    
    if (![(id)[self conferenceId] isEqual:[aConferenceRating conferenceId]])
        return NO;
    
    if (![[self presentationId] isEqual:[aConferenceRating presentationId]])
        return NO;
    
    return YES;
}

- (NSUInteger)hash {
    return [self.conferenceId hash] ^ [self.presentationId hash];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.dateTaken = [decoder decodeObjectForKey:@"date"];
    self.conferenceId = [decoder decodeObjectForKey:@"conferenceId"];
    self.presentationId = [decoder decodeObjectForKey:@"presentationId"];
    self.value = [decoder decodeObjectForKey:@"value"];
    self.sent = [decoder decodeObjectForKey:@"sent"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.dateTaken forKey:@"date"];
    [encoder encodeObject:self.conferenceId forKey:@"conferenceId"];
    [encoder encodeObject:self.presentationId forKey:@"presentationId"];
    [encoder encodeObject:self.value forKey:@"value"];
    [encoder encodeObject:self.sent forKey:@"sent"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<conference Id: %@, presentation Id: %@>", self.conferenceId, self.presentationId];
}

@end