//
//  Post.m
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize identifier, type, slug, url, status, title, title_plain, content, excerpt, date, modified, comment_count, comment_status;


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
      comment_status:(NSString *)comment_status {

    Post *post = [[self alloc] init];

    post.identifier = identifier;
    post.type = type;
    post.slug = slug;
    post.url = url;
    post.status = status;
    post.title = title;
    post.title_plain = title_plain;
    post.content = content;
    post.excerpt = excerpt;
    post.date = date;
    post.modified = modified;
    post.comment_count = comment_count;
    post.comment_status = comment_status;

    return post;
}

+ (Post *)deserializeFromJson:(NSDictionary *)json {
    return [Post postWithId:[json objectForKey:@"id"]
                       type:[json objectForKey:@"type"]
                       slug:[json objectForKey:@"slug"]
                        url:[json objectForKey:@"url"]
                     status:[json objectForKey:@"status"]
                      title:[json objectForKey:@"title"]
                title_plain:[json objectForKey:@"title_plain"]
                    content:[json objectForKey:@"content"]
                    excerpt:[json objectForKey:@"excerpt"]
                       date:[json objectForKey:@"date"]
                   modified:[json objectForKey:@"modified"]
              comment_count:[json objectForKey:@"comment_count"]
             comment_status:[json objectForKey:@"comment_status"]
    ];
}


- (NSDictionary*) getAsDictionary {
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
            identifier,@"id",
                  type,@"type",
                  slug,@"slug",
                   url,@"url",
                status,@"status",
                 title,@"title",
           title_plain,@"title_plain",
               content,@"content",
               excerpt,@"excerpt",
                  date,@"date",
              modified,@"modified",
         comment_count,@"comment_count",
        comment_status,@"comment_status",
            nil];

    return dict;
}


@end
