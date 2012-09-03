//
//  UIColor+RKXBAdditions.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/08/12.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (RKXBAdditions)

// wrapper for [UIColor colorWithRed:green:blue:alpha:]
// values must be in range 0 - 255
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

// Creates color using hex representation
// hex - must be in format: #FF00CC
// alpha - must be in range 0.0 - 1.0
+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;

@end
