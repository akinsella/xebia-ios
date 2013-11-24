//
// Created by Alexis Kinsella on 11/11/2013.
// Copyright (c) 2013 Xebia. All rights reserved.
//


#import "XBAbstractURLHandler.h"
#import "XBToolkit.h"
#import "XBAppDelegate.h"
#import "XBNavigationController.h"


@implementation XBAbstractURLHandler


- (XBAppDelegate *) appDelegate {
    return (XBAppDelegate *) UIApplication.sharedApplication.delegate;
}

- (BOOL)handleURL:(NSURL *)url {
    mustOverride();
}

- (void)processURL:(NSURL *)url {
    mustOverride();
}

- (void)fetchDataFromSourceWithResourcePath:(NSString *)path success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure {

    XBNavigationController *navigationController = (XBNavigationController *)self.appDelegate.mainViewController.frontViewController;
    [navigationController showProgressHUD];

    [self.appDelegate.configurationProvider.httpClient executeGetJsonRequestWithPath:path parameters:nil
                                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                 [navigationController dismissProgressHUDWithCallback:^{
                                                                                     if (success) {
                                                                                         success(JSON);
                                                                                     }
                                                                                 }];
                                                                             }
                                                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                 [navigationController showErrorProgressHUDWithCallback:^{
                                                                                     if (failure) {
                                                                                         failure(error);
                                                                                     }
                                                                                 }];
                                                                             }
    ];
}

@end