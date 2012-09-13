//
//  WPAttachment.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface WPAttachment : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *mime_type;
@property (nonatomic, strong) NSNumber *parent;

@end