//
//  WPComment.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

@interface WPComment : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *parent;

@end
