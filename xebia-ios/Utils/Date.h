//
//  Date.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 19/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Date : NSObject
+ (NSDate *)parseDate:(NSString *)dateStr withFormat:format;
+(NSString *) formattedDateRelativeToNow:(NSDate *)date;
@end

