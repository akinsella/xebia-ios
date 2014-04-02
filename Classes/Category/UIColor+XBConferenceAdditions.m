//
// Created by Simone Civetta on 02/04/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "UIColor+XBConferenceAdditions.h"
#import "UIColor+XBAdditions.h"


@implementation UIColor (XBConferenceAdditions)

+ (NSArray *)trackColors {
    static dispatch_once_t once;
    static NSArray *trackColors;
    dispatch_once(&once, ^ {
        trackColors = @[
                [UIColor colorWithHex:@"#b7a93d"],
                [UIColor colorWithHex:@"#205f59"],
                [UIColor colorWithHex:@"#b83d73"],
                [UIColor colorWithHex:@"#7dd4ca"],
                [UIColor colorWithHex:@"#7d7c2a"],
                [UIColor colorWithHex:@"#592c84"],
                [UIColor colorWithHex:@"#7c5fca"],
                [UIColor colorWithHex:@"#7aca5f"],
                [UIColor colorWithHex:@"#4e1a4c"],
                [UIColor colorWithHex:@"#d3d787"],
                [UIColor colorWithHex:@"#4b86c3"],
                [UIColor colorWithHex:@"#be673f"],
                [UIColor colorWithHex:@"#1c2754"],
                [UIColor colorWithHex:@"#133a34"],
                [UIColor colorWithHex:@"#a1ade0"],
                [UIColor colorWithHex:@"#36a396"],
                [UIColor colorWithHex:@"#152f10"],
                [UIColor colorWithHex:@"#cf97dc"],

        ];
    });
    return trackColors;
}

+ (UIColor *)colorWithTrackIdentifier:(NSString *)trackIdentifier {
    int trackValue = [trackIdentifier hash] % [[UIColor trackColors] count];
    return [UIColor trackColors][trackValue];
}

@end