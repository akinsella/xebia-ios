//
// Created by akinsella on 04/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TTTweet.h"
#import "Date.h"
#import "TTRetweetedStatus.h"


@implementation TTRetweetedStatus

    - (NSString *)dateFormatted {
        return [Date formattedDateRelativeToNow: self.created_at];
    }

@end