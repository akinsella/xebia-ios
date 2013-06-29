//
// Created by Alexis Kinsella on 23/06/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "XBMappingProvider.h"


//display_name: "Xebia France"
//id: "7660426"
//is_plus: "0"
//is_pro: "1"
//is_staff: "0"
//profileurl: "http://vimeo.com/xebia"
//realname: "Xebia France"
//username: "xebia"
//videosurl: "http://vimeo.com/xebia/videos"

@interface VMUser: NSObject<XBMappingProvider>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, assign) Boolean isPlus;
@property (nonatomic, assign) Boolean isPro;
@property (nonatomic, assign) Boolean isStaff;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *profileUrl;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *videosUrl;

@end