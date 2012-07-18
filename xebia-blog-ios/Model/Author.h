//
//  Author.h
//  Xebia Application
//
//  Created by Alexis Kinsella on 14/06/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Author : NSObject

@property (nonatomic,assign) int identifier;

@property (nonatomic,copy) NSString *slug;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *firstname;
@property (nonatomic,copy) NSString *lastname;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *description;

+ (id)authorWithId:(int)identifier
                slug:(NSString *)slug
                name:(NSString *)name

           firstname:(NSString *)firstname
            lastname:(NSString *)lastname
            nickname:(NSString *)nickname

                 url:(NSString *)url
         description:(NSString *)description;

@end
