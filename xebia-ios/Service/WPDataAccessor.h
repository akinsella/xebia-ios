//
//  WPDataAccessor.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 18/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Post.h"

@interface WPDataAccessor : NSObject

@property(nonatomic, retain) NSString *baseApiUrl;

+ (id) initWithBaseApiUrl:(NSString *)url;

- (id)initWithBaseApiUrl:(NSString *)baseApiUrl;

-(NSMutableArray *) fetchPostsWithPostType:(POST_TYPE)postType Id:(int)identifier Count:(int)count;

@end
