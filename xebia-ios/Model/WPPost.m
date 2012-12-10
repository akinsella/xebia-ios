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

@interface WPPost()
@property(nonatomic, strong)NSDateFormatter *df;
@end

@implementation WPPost

-(id)init {
    self = [super init];

    if (self) {
        [self initDateFormatters];
    }

    return self;
}

- (void)initDateFormatters {
    self.df = [NSDateFormatter initWithDateFormat: @"'Le 'dd'/'MM'/'yyyy', à 'HH':'mm"];
}

- (NSString *)description_ {
    return [NSString stringWithFormat:@"%@ commentaire%@", self.comment_count, self.comment_count.intValue > 1 ? @"s" :@"" ];
//    NSRange range = {0, MIN([self.excerpt length], 255)};
//    NSRange rangeOfComposedCharacterSequences = [self.excerpt rangeOfComposedCharacterSequencesForRange: range];
//    return [NSString stringWithFormat:@"%@ ...", [self.excerpt substringWithRange:rangeOfComposedCharacterSequences] ];
}

- (NSString *)dateFormatted {
    return [NSString stringWithFormat:@"%@", [self.df stringFromDate:self.date]];
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

+ (RKObjectMapping *)mappingForOne {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class] usingBlock:^(RKObjectMapping *mapping) {
        mapping.rootKeyPath = @"post";
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
