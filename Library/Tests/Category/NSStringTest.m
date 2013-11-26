//
// Created by Alexis Kinsella on 08/04/13.
// Copyright (c) 2013 Xebia IT Architets. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSString+XBAdditions.h"
#import "PKTokenizer.h"

#import <SenTestingKit/SenTestingKit.h>

@interface NSStringTest : SenTestCase @end


@implementation NSStringTest

-(void)testShouldConvertStringToIndexSet {
    NSIndexSet * indexSet = [@"23,34,45" asIndexSet];

    STAssertEquals([indexSet count], 3U, nil);
    STAssertEquals([indexSet firstIndex], 23U, nil);
    STAssertEquals([indexSet indexGreaterThanIndex:23], 34U, nil);
    STAssertEquals([indexSet lastIndex], 45U, nil);
}

-(void)testShouldConvertStringToOneValueIndexSet {
    NSIndexSet * indexSet = [@"23" asIndexSet];

    STAssertEquals([indexSet count], 1U, nil);
    STAssertEquals([indexSet firstIndex], 23U, nil);
}

-(void)testSyntaxHighlight {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    NSString *source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    NSAttributedString *attributedString = [source highlightSyntax];

    STAssertNotNil(attributedString, nil);

}

@end
