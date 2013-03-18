//
//  WPPost.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "WPSPost.h"
#import "GravatarHelper.h"
#import "NSDateFormatter+XBAdditions.h"
#import "USArrayWrapper.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCObjectMapping.h"
#import "WPSTag.h"
#import "DCArrayMapping.h"
#import "WPSCategory.h"
#import "DCParserConfiguration+XBAdditions.h"

@implementation WPSPost

- (NSString *)description_ {
    return [NSString stringWithFormat:@"%@ commentaire%@", self.commentCount, self.commentCount.intValue > 1 ? @"s" :@"" ];
//    NSRange range = {0, MIN([self.excerpt length], 255)};
//    NSRange rangeOfComposedCharacterSequences = [self.excerpt rangeOfComposedCharacterSequencesForRange: range];
//    return [NSString stringWithFormat:@"%@ ...", [self.excerpt substringWithRange:rangeOfComposedCharacterSequences] ];
}

- (NSString *)dateFormatted {
    return [NSString stringWithFormat:@"%@", [[NSDateFormatter initWithDateFormat: @"'Le 'dd'/'MM'/'yyyy', à 'HH':'mm"] stringFromDate:self.date]];
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

+(DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"description" toAttribute:@"description_" onClass:[self class]]];

    [config mergeConfig:[[WPSAuthor class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[WPSTag class] forAttribute:@"tags" onClass:[self class]]];
    [config mergeConfig:[[WPSTag class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[WPSCategory class] forAttribute:@"categories" onClass:[self class]]];
    [config mergeConfig:[[WPSCategory class] mappings]];

    return config;
}

@end
