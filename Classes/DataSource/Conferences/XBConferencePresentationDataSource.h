//
// Created by Simone Civetta on 22/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBReloadableArrayDataSource.h"

@class XBConferencePresentationDetail;


@interface XBConferencePresentationDataSource : XBReloadableArrayDataSource
- (instancetype)initWithResourcePath:(NSString *)resourcePath;

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath;

- (void)loadPresentationWithId:(NSNumber *)presentationIdentifier callback:(void (^)(XBConferencePresentationDetail *))callback;
@end