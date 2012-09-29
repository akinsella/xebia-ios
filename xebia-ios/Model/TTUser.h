//
//  TTUser.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface TTUser : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profile_image_url;

@property (nonatomic, strong, readonly) NSURL *avatarImageUrl;

+ (RKObjectMapping *)mapping;

@end

