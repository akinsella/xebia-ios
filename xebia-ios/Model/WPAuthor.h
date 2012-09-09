//
//  WPAuthor.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPAuthor : NSManagedObject
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *description_;

@property (nonatomic, strong, readonly) NSURL *avatarImageUrl;

@end

