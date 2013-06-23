//
//  GravatarHelper.h
//  Gravatar
//
//  Created by Mugunth Kumar on 11-Sep-10.
//  Copyright 2010 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GravatarHelper : NSObject
+ (NSURL*) getGravatarURL:(NSString *) emailAddress;
+ (NSURL*) getGravatarURLWithGravatarId:(NSString *) gravatarId;
+ (NSString*)getMd5:(NSString*)data;

@end
