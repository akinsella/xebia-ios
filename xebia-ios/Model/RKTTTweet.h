//
//  RKWPAuthor.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKTTUser.h"

@interface RKTTTweet : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) RKTTUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, readonly) NSString *dateFormatted;

@end

