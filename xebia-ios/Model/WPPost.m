//
//  WPPost.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPPost.h"
#import "WPTag.h"
#import "WPCategory.h"
#import "GravatarHelper.h"
#import "NSDateFormatter+XBAdditions.h"
#import "USArrayWrapper.h"

@implementation WPPost {
    NSDateFormatter *_df;
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
    _df = [[NSDateFormatter initWithDateFormat: @"'Le 'dd'/'MM'/'yyyy', à 'HH':'mm"] retain];
}

- (NSString *)description_ {
    return [NSString stringWithFormat:@"%@ commentaire%@", comment_count, comment_count.intValue > 1 ? @"s" :@"" ];
//    NSRange range = {0, MIN([self.excerpt length], 255)};
//    NSRange rangeOfComposedCharacterSequences = [self.excerpt rangeOfComposedCharacterSequencesForRange: range];
//    return [NSString stringWithFormat:@"%@ ...", [self.excerpt substringWithRange:rangeOfComposedCharacterSequences] ];
}

- (NSString *)dateFormatted {
    return [NSString stringWithFormat:@"%@", [_df stringFromDate:self.date]];
}

- (NSString *)authorFormatted {
    NSString *authorFormatted = [NSString stringWithFormat:@"%@", self.author.name ? self.author.name : self.author.nickname];
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
    return [GravatarHelper getGravatarURL: [NSString stringWithFormat:@"%@@xebia.fr", self.author.nickname]];
}

- (void)dealloc {
    [_df release];
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

    // Relationships
    [mapping hasMany:@"tags" withMapping:[WPTag mapping]];
    [mapping hasMany:@"categories" withMapping:[WPCategory mapping]];
    [mapping hasMany:@"author" withMapping:[WPAuthor mapping]];

    return mapping;
}

@end
