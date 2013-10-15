//
//  NSString+XBAdditions.m
//  LaCentrale
//
//  Created by Simone Civetta on 4/1/13.
//  Copyright (c) 2013 Xebia IT Architets. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+XBAdditions.h"

@implementation NSString (XBAdditions)

- (BOOL)insensitiveContainsString:(NSString *)subString {
    return [[self uppercaseString] rangeOfString:[subString uppercaseString]].location != NSNotFound;
}

-(NSURL *) url {
    return [NSURL URLWithString:self];
}


- (NSIndexSet *)asIndexSet {
    NSArray* elements = [self componentsSeparatedByString: @","];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];

    for (NSString * element in elements) {
        [indexSet addIndex:(NSUInteger)[element integerValue]];
    }

    return [indexSet copy];
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

@end
