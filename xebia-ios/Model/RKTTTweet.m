    //
//  RKWPAuthor.m
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RKTTTweet.h"
#import "RKTTUser.h"
#import "Date.h"

@implementation RKTTTweet

@dynamic identifier;
@dynamic created_at;
@dynamic user;
@dynamic text;

- (NSString *)dateFormatted {
    return [Date formattedDateRelativeToNow: self.created_at];
}


@end

