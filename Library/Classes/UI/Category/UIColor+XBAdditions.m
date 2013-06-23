//
//  UIColor+XBAdditions.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 26/08/12.
//
//

#import "UIColor+XBAdditions.h"

@implementation UIColor (XBAdditions)

+ (UIColor*)colorWithPatternImageName:(NSString *)imageName {
    
    UIColor* color = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
    
    return color;
}

+ (UIColor*)colorWith8BitRed:(NSInteger)red
                       green:(NSInteger)green
                        blue:(NSInteger)blue
                       alpha:(CGFloat)alpha {
    
    UIColor* color = [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
    
    return color;
}

+ (UIColor*)colorWithHex:(NSString*)hex {
    return [self colorWithHex:hex alpha:1.0];
}

+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha {
    
    NSUInteger hexLength = [hex length];
    assert( (7 == hexLength && '#' == [hex characterAtIndex:0]) || (4 == hexLength && '#' == [hex characterAtIndex:0]) );
    
    NSString *redHex = nil;
    NSString *greenHex = nil;
    NSString *blueHex = nil;

    if (7 == hexLength) {
        redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
        greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(3, 2)]];
        blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(5, 2)]];
    }
    else if (6 == hexLength) {
        redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(0, 2)]];
        greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(2, 2)]];
        blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(4, 2)]];
    }
   
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [UIColor colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
}

@end
