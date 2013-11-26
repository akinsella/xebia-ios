//
//  NSString+XBAdditions.m
//  LaCentrale
//
//  Created by Simone Civetta on 4/1/13.
//  Copyright (c) 2013 Xebia IT Architets. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+XBAdditions.h"
#import "XBConstants.h"
#import "UIColor+XBAdditions.h"
#import <ParseKit/ParseKit.h>
#import "PKParserFactory.h"
#import "NSArray+ParseKitAdditions.h"
#import "PKTokenizer.h"
#import "XBLogging.h"

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

- (NSString *)stripLeadingSlash {
    if (self.length == 0 || ![[self substringToIndex:1] isEqualToString:@"/"]) {
        return self;
    }
    return [self substringFromIndex:1];
}

- (NSString *)suffixIfIOS7 {
    BOOL isIOS7 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
    return isIOS7 ? [NSString stringWithFormat:@"%@-ios7", self] : self;
}

- (id)objectFromJSONString {
    NSError *error;
    return [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding:NSUTF8StringEncoding]
                                           options: NSJSONReadingMutableContainers
                                             error: &error];
}

-(NSAttributedString *)highlightSyntax {
    return [self highlightSyntaxWithFont: nil];
}

-(NSAttributedString *)highlightSyntaxWithFont:(UIFont *)font {

    PKTokenizer *t = [PKTokenizer tokenizerWithString:self];
    PKToken *eof = [PKToken EOFToken];
    PKToken *token = nil;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:@{
            UITextAttributeFont: font ? font : [UIFont systemFontOfSize:14],
            UITextAttributeTextColor: [UIColor blackColor]
    }];

    NSDate *start = [NSDate date];
    while ((token = t.nextToken) != eof) {

        NSString *tokenStringValue = token.stringValue;
        NSUInteger length = tokenStringValue.length;
//        XBLogDebug(@"tok: %@", token.debugDescription);

        UIColor *color = [UIColor colorWithHex:@"#E0E0E0"];
        if (token.quotedString) {
            color = [UIColor colorWithHex: @"#A5C15B"];
        }
        else if (token.isEmail) {
            color = [UIColor colorWithHex: @"#6795BA"];
        }
        else if (token.isURL) {
            color = [UIColor colorWithHex: @"#6795BA"];
        }
        else if (token.isComment) {
            color = [UIColor colorWithHex: @"#808080"];
        }
        else if (token.isSymbol) {
            color = [UIColor colorWithHex: @"#CC7731"];
        }

        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(token.offset, length)];
    }

    double secs = -([start timeIntervalSinceNow]);

    XBLogDebug(@"tokenize: %f", secs);

//    XBLogDebug(@"Attributed String: %@", attributedString);

    return attributedString;
}


@end
