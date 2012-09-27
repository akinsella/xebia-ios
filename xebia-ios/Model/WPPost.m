//
//  WPPost.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WPPost.h"
#import "GravatarHelper.h"
#import "NSDateFormatter+XBAdditions.h"
#import "USArrayWrapper.h"

@implementation WPPost {
    NSDateFormatter *_dfDate;
    NSDateFormatter *_dfTime;
}

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

@dynamic author;
@dynamic tags;
@dynamic categories;
@dynamic comments;

- (id)init {
    self = [super init];
    if (self) {
        _dfDate = [[NSDateFormatter initWithDateFormat: @"yyyy-MM-dd"] retain];
        _dfTime = [[NSDateFormatter initWithDateFormat: @"HH:mm:ss"] retain];
    }

    return self;
}

- (NSString *)excerptTrim {
    NSRange range = {0, MIN([self.excerpt length], 255)};
    NSRange rangeOfComposedCharacterSequences = [self.excerpt rangeOfComposedCharacterSequencesForRange: range];
    return [NSString stringWithFormat:@"%@ ...", [self.excerpt substringWithRange:rangeOfComposedCharacterSequences] ];
}

- (NSString *)dateFormatted {
    return [NSString stringWithFormat: @"Le %@ à %@", [_dfDate stringFromDate:self.date], [_dfTime stringFromDate:self.date]];
}

- (NSString *)tagsFormatted {
    return [_array(self.tags).pluck(@"title").unwrap componentsJoinedByString:@", "];
}

- (NSString *)categoriesFormatted {
    return [_array(self.categories).pluck(@"title").unwrap componentsJoinedByString:@", "];
}

- (NSString *)authorFormatted {
    return [NSString stringWithFormat: @"Par %@", self.author.name];
}

- (NSURL *)imageUrl {
    return [GravatarHelper getGravatarURL: [NSString stringWithFormat:@"%@@xebia.fr", @"akinsella"]];
}

- (void)dealloc {
    [_dfDate release];
    [_dfTime release];
    [super dealloc];
}

@end
