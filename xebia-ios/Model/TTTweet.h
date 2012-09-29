//
//  TTTweet.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUser.h"
#import <RestKit/RestKit.h>

@interface TTTweet : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) TTUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, readonly) NSString *dateFormatted;

+ (RKObjectMapping *)mapping;

@end

