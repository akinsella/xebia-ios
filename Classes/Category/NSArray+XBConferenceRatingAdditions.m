//
// Created by Simone Civetta on 16/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Underscore.m/Underscore.h>
#import "NSArray+XBConferenceRatingAdditions.h"
#import "XBConferenceRating.h"
#import "XBConferencePresentation.h"


@implementation NSArray (XBConferenceRatingAdditions)

- (NSArray *)presentationIdentifiers {
    return Underscore.arrayMap(self, ^(XBConferenceRating *rating) {
        return rating.presentationId;
    });
}

- (NSArray *)mappedArrayForIdentifiers:(NSArray *)identifiers {
    NSArray *values = [self copy];
    return Underscore.arrayMap(identifiers, ^(NSString *identifier) {
        XBConferencePresentation *mappedPresentation = Underscore.find(values, ^(XBConferencePresentation *presentation) {
            return [presentation.identifier isEqualToString:identifier];
        });
        return mappedPresentation ? mappedPresentation : [NSNull null];
    });
}

@end