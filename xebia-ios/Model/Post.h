//
//  Post.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property(nonatomic, copy) NSNumber *identifier;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *slug;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *title_plain;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *excerpt;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *modified;
@property(nonatomic, copy) NSNumber *comment_count;
@property(nonatomic, copy) NSString *comment_status;

+ (Post *)postWithId:(NSNumber *)identifier
                type:(NSString *)type
                slug:(NSString *)slug
                 url:(NSString *)url
              status:(NSString *)status
               title:(NSString *)title
         title_plain:(NSString *)title_plain
             content:(NSString *)content
             excerpt:(NSString *)excerpt
                date:(NSString *)date
            modified:(NSString *)modified
       comment_count:(NSNumber *)comment_count
      comment_status:(NSString *)comment_status
;

+ (Post *)deserializeFromJson:(NSDictionary *)json;

- (NSDictionary*) getAsDictionary;

@end
