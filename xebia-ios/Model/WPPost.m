//
//  WPPost.m
//  xebia-blog-ios
//
//  Created by Alexis Kinsella on 21/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WPPost.h"
#import "GravatarHelper.h"

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

- (NSURL *)imageUrl {
    return [GravatarHelper getGravatarURL: [NSString stringWithFormat:@"%@@xebia.fr", @"akinsella"]];
}

@end
