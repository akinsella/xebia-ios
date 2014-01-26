//
//  XBLocalJsonDataLoader.h
//  Xebia
//
//  Created by Simone Civetta on 26/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBDataLoader.h"

@interface XBLocalJsonDataLoader : NSObject<XBDataLoader>

+ (instancetype)dataLoaderWithResourcePath:(NSString *)resourcePath;

- (instancetype)initWithResourcePath:(NSString *)resourcePath;

@end
