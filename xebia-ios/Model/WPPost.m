//
//  WPPost.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WPPost.h"
#import "GravatarHelper.h"
#import "Date.h"

@implementation WPPost

@dynamic identifier;
@dynamic type;
@dynamic slug;
@dynamic url;
@dynamic status;
@dynamic title;
@dynamic title_plain;
@dynamic content;
@dynamic excerpt;
@dynamic date;
@dynamic modified;
@dynamic comment_count;
@dynamic comment_status;

- (NSString *)excerptTrim {
    NSRange range = {0, MIN([self.excerpt length], 255)};
    NSRange rangeOfComposedCharacterSequences = [self.excerpt rangeOfComposedCharacterSequencesForRange: range];
    return [self.excerpt substringWithRange:rangeOfComposedCharacterSequences];
}

- (NSString *)dateFormatted {
    return [Date formattedDateRelativeToNow: self.date];
}

- (NSURL *)imageUrl {
    return [GravatarHelper getGravatarURL: [NSString stringWithFormat:@"%@@xebia.fr", @"akinsella"]];
}

@end
