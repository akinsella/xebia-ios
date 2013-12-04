//
// Created by Alexis Kinsella on 19/04/13.
// Copyright (c) 2013 Xebia. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AFNetworking/AFNetworking.h>
#import "XBHttpUtils.h"


@implementation XBHttpUtils


+(void)downloadFileWithUrl:(NSURL *)url
                      path:(NSString *)path
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    [self downloadFileWithUrl:url
                                path:path
                              method:@"GET"
                              append:NO
                             success:success
                             failure:failure];
}

+(void)downloadFileWithUrl:(NSURL *)url 
                    path:(NSString *)path
                  method:(NSString *)method
                  append:(BOOL) append
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success                                           
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSURLRequest *urlRequest = [self urlRequestWithURL:url method:method];
    AFHTTPRequestOperation *operation = [self operationWithUrl:urlRequest];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:append];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            failure(operation, error);
        }
    }];
    [operation start];
}

+ (AFHTTPRequestOperation *)operationWithUrl:(NSURLRequest *)urlRequest {
    return [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
}

+ (NSMutableURLRequest *)urlRequestWithURL:(NSURL *)url method:(NSString *)method {
    NSMutableDictionary *urlQueryParams = [self urlQueryParamsWithURL:url];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    return [manager.requestSerializer requestWithMethod:method URLString:[url absoluteString] parameters:urlQueryParams];
}

+ (NSMutableDictionary *)urlQueryParamsWithURL:(NSURL *)url {
    NSMutableDictionary *urlQueryParams = [NSMutableDictionary dictionary];
    NSArray *components = [url.query componentsSeparatedByString:@"&"];
    for (NSString *component in components) {
        NSArray *subComponents = [component componentsSeparatedByString:@"="];
        [urlQueryParams setObject:[[subComponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           forKey:[[subComponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    return urlQueryParams;
}

@end