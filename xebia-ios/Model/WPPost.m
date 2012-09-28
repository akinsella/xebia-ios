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

-(void)awakeFromFetch {
    [super awakeFromInsert];
    [self initDateFormatters];
}

-(void)awakeFromInsert {
    [super awakeFromInsert];
    [self initDateFormatters];
}

- (void)initDateFormatters {
    _dfDate = [[NSDateFormatter initWithDateFormat: @"dd'/'MM'/'yyyy"] retain];
    _dfTime = [[NSDateFormatter initWithDateFormat: @"HH':'mm"] retain];
}

- (NSString *)excerptTrim {
    NSRange range = {0, MIN([self.excerpt length], 255)};
    NSRange rangeOfComposedCharacterSequences = [self.excerpt rangeOfComposedCharacterSequencesForRange: range];
    return [NSString stringWithFormat:@"%@ ...", [self.excerpt substringWithRange:rangeOfComposedCharacterSequences] ];
}

- (NSString *)dateFormatted {
    NSString *date = [_dfDate stringFromDate:self.date];
    NSString *time = [_dfTime stringFromDate:self.date];
    return [NSString stringWithFormat:@"Le %@, à %@", date, time];
}

- (NSString *)authorFormatted {
    NSString *authorFormatted = [NSString stringWithFormat:@"Par %@", self.author.name];
    return authorFormatted;
}

- (NSString *)tagsFormatted {
    NSArray *tagTitles = _array(self.tags).pluck(@"title").unwrap;
    NSString *tagsFormatted = [tagTitles componentsJoinedByString:@", "];
    return tagsFormatted;
}

- (NSString *)categoriesFormatted {
    NSArray *categoryTitles = _array(self.categories).pluck(@"title").unwrap;
    NSString *categoriesFormatted = [categoryTitles componentsJoinedByString:@", "];
    return categoriesFormatted;
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
