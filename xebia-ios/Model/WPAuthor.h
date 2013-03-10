//
//  WPAuthor.h
//  xebia-ios
//
//  Created by Alexis Kinsella on 24/07/12.
//  Copyright (c) 2012 Xebia France. All rights reserved.
//

@interface WPAuthor : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *description_;

- (NSURL *)avatarImageUrl;
- (NSString *)uppercaseFirstLetterOfName;

@end

