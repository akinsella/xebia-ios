    //
//  RKWPAuthor.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKTTTweet.h"
#import "RKTTUser.h"
#import "SDWebImageManager.h"
#import "GravatarHelper.h"
#import "SDImageCache.h"
#import "Date.h"

@implementation RKTTTweet

@dynamic identifier;
@dynamic created_at;
@dynamic user;
@dynamic text;

- (NSString *)dateFormatted {
    // "Mon Jun 27 19:32:19 +0000 2011"
    // NSLog(@"Date: '%@' from: '%@'",date, [self created_at]);
    
    return [Date formattedDateRelativeToNow: self.created_at];
}


@end

