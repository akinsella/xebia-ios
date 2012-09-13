//
//  UIColorTest.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 11/09/12.
//
//

#import "UIColorTest.h"
#import "UIColor+XBAdditions.h"

@implementation UIColorTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testColorWith8BitRedGgreenBlueAlpha
{
    UIColor *color = [UIColor colorWith8BitRed:255 green:255 blue:255 alpha:0];
    NSLog(@"White color: %@", [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]);
    STAssertEqualObjects([UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0], color, @"Color was not the one expected: %@", color);
}

@end
