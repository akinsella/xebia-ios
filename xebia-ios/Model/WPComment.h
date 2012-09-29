//
//  WPComment.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface WPComment : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *parent;

+ (RKObjectMapping *)mapping;

@end
