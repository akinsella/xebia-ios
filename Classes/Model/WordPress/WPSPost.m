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
#import "Underscore.h"

@implementation WPSPost

- (NSString *)description_ {
    return [NSString stringWithFormat:@"%@ commentaire%@", self.commentCount, self.commentCount.intValue > 1 ? @"s" :@"" ];
//    NSRange range = {0, MIN([self.excerpt length], 255)};
//    NSRange rangeOfComposedCharacterSequences = [self.excerpt rangeOfComposedCharacterSequencesForRange: range];
//    return [NSString stringWithFormat:@"%@ ...", [self.excerpt substringWithRange:rangeOfComposedCharacterSequences] ];
}

- (NSString *)authorFormatted {
    NSString *authorFormatted = [NSString stringWithFormat:@"%@", self.primaryAuthor.name ? self.primaryAuthor.name : self.primaryAuthor.nickname];
    return authorFormatted;
}

- (NSString *)tagsFormatted {
    NSArray *tagTitles = Underscore.pluck(self.tags, @"title");
    NSString *tagsFormatted = [tagTitles componentsJoinedByString:@", "];
    return tagsFormatted;
}

- (NSString *)categoriesFormatted {
    NSArray *categoryTitles = Underscore.pluck(self.categories, @"title");
    NSString *categoriesFormatted = [categoryTitles componentsJoinedByString:@", "];
    return categoriesFormatted;
}

-(WPSAuthor *)primaryAuthor {
    return self.authors[0];
}

- (NSURL *)imageUrl {
    return [GravatarHelper getGravatarURL: [NSString stringWithFormat:@"%@@xebia.fr", self.primaryAuthor.nickname]];
}

+(DCParserConfiguration *)mappings {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"yyyy-MM-dd HH:mm:ss";

    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"id" toAttribute:@"identifier" onClass:[self class]]];
    [config addObjectMapping: [DCObjectMapping mapKeyPath:@"description" toAttribute:@"description_" onClass:[self class]]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[WPSAuthor class] forAttribute:@"authors" onClass:[self class]]];
    [config mergeConfig:[[WPSAuthor class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[WPSTag class] forAttribute:@"tags" onClass:[self class]]];
    [config mergeConfig:[[WPSTag class] mappings]];

    [config addArrayMapper: [DCArrayMapping mapperForClassElements:[WPSCategory class] forAttribute:@"categories" onClass:[self class]]];
    [config mergeConfig:[[WPSCategory class] mappings]];

    return config;
}

@end
