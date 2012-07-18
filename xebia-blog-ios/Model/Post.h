//
//  Post.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic,assign) int identifier;

@property (nonatomic,copy) IBOutlet NSString *title;
@property (nonatomic,copy) IBOutlet NSString *excerpt;
@property (nonatomic,copy) IBOutlet NSString *date;
@property (nonatomic,copy) IBOutlet NSString *modified;
@property (nonatomic,copy) IBOutlet NSString *slug;
@property (nonatomic,copy) IBOutlet NSString *type;

+ (id)postWithId:(int)identifier
           title:(NSString *)title
         excerpt:(NSString *)excerpt
            date:(NSString *)date
        modified:(NSString *)modified
            slug:(NSString *)slug
            type:(NSString *)type;

typedef enum {
    TAG = 1,
    CATEGORY = 2,
    AUTHOR = 3
} POST_TYPE;

@end
