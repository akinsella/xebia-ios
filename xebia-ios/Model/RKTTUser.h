//
//  RKWPAuthor.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface RKTTUser : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *profile_image_url;

@end

