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
                [UIColor colorWithHex:@"#3498db"],
                [UIColor colorWithHex:@"#16a085"],
                [UIColor colorWithHex:@"#f1c40f"],
                [UIColor colorWithHex:@"#f39c12"],
                [UIColor colorWithHex:@"#2ecc71"],
                [UIColor colorWithHex:@"#27ae60"],
                [UIColor colorWithHex:@"#d35400"],
                [UIColor colorWithHex:@"#9b59b6"],
                [UIColor colorWithHex:@"#3498db"],
                [UIColor colorWithHex:@"#2980b9"],
                [UIColor colorWithHex:@"#e74c3c"],
                [UIColor colorWithHex:@"#c0392b"],
                [UIColor colorWithHex:@"#e67e22"],
                [UIColor colorWithHex:@"#8e44ad"],
                [UIColor colorWithHex:@"#34495e"],
                [UIColor colorWithHex:@"#bdc3c7"],
                [UIColor colorWithHex:@"#152f10"],
                [UIColor colorWithHex:@"#cf97dc"]
        ];
    });
    return trackColors;
}

+ (UIColor *)colorWithTrackIdentifier:(NSString *)trackIdentifier {
    int trackValue = [trackIdentifier hash] % [[UIColor trackColors] count];
    return [UIColor trackColors][trackValue];
}

+ (UIColor *)xebiaPurpleColor {
    return [UIColor colorWithRed:0.416 green:0.125 blue:0.373 alpha:1];
}

@end