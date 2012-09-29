//
//  WPPost.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPPost.h"
#import "GravatarHelper.h"
#import "NSDateFormatter+XBAdditions.h"
#import "USArrayWrapper.h"

@implementation WPPost {
    NSDateFormatter *_dfDate;
    NSDateFormatter *_dfTime;
}

@synthesize identifier;
@synthesize type;
@synthesize slug;
@synthesize url;
@synthesize status;
@synthesize title;
@synthesize title_plain;
@synthesize content;
@synthesize excerpt;
@synthesize date;
@synthesize modified;
@synthesize comment_count;
@synthesize comment_status;

@synthesize author;
@synthesize tags;
@synthesize categories;
@synthesize comments;

-(id)init {
    self = [super init];

    if (self) {
        [self initDateFormatters];
    }

    return self;
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

+ (RKObjectMapping *)mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        mapping.rootKeyPath = @"posts";
        [mapping mapAttributes:@"type", @"slug", @"url", @"status", @"title", @"title_plain", @"content", @"excerpt", @"date", @"modified", @"comment_count", @"comment_status", nil];
        [mapping mapKeyPathsToAttributes:
                @"id", @"identifier",
                nil];
    }];

    return mapping;
}

@end
