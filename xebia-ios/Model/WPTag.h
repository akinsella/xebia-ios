//
//  WPTag.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface WPTag : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSNumber *post_count;

@property (nonatomic, retain, readonly) NSString *capitalizedTitle;

@property (nonatomic, readonly) NSInteger postCount;

+ (RKObjectMapping *)mapping;

@end
