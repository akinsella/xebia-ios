//
// Created by Alexis Kinsella on 19/04/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"
#import "AFNetworkActivityLogger.h"

@interface XBHttpUtils : NSObject

+(void)downloadFileWithUrl:(NSURL *)url
                      path:(NSString *)path
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)downloadFileWithUrl:(NSURL *)url
                      path:(NSString *)path
                    method:(NSString *)method
                    append:(BOOL) append
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end