//
//  RKWPAuthor.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKTTUser.h"
#import "SDWebImageManager.h"

@interface RKTTTweet : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) RKTTUser *user;
@property (nonatomic, strong) NSString *text;

@end

