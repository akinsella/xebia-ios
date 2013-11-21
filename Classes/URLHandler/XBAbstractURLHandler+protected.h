//
// Created by Alexis Kinsella on 11/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XBAbstractURLHandler.h"


@interface XBAbstractURLHandler(protected)

- (void)fetchDataFromSourceWithResourcePath:(NSString *)path
                                    success:(void (^)(id JSON))success
                                    failure:(void (^)(NSError *error))failure;

@end