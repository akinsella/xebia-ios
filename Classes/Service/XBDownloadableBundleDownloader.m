//
//  XBDownloadableBundleDownloader.m
//  Xebia
//
//  Created by Simone Civetta on 25/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "XBDownloadableBundleDownloader.h"
#import "XBConference.h"
#import "AFHTTPRequestOperation.h"

@interface XBDownloadableBundleDownloader ()

@property (nonatomic, strong) id<XBDownloadableBundle> downloadableBundle;

@end

@implementation XBDownloadableBundleDownloader

- (instancetype)initWithDownloadableBundle:(id <XBDownloadableBundle>)downloadableBundle
{
    self = [super init];
    if (self) {
        self.downloadableBundle = downloadableBundle;
    }
    return self;
}

+ (instancetype)downloaderWithDownloadableBundle:(id <XBDownloadableBundle>)downloadableBundle
{
    return [[self alloc] initWithDownloadableBundle:downloadableBundle];
}

- (NSString *)rootFolder
{
    return @"rootFolder";
}

- (void)downloadAllResources:(void (^)(NSError *error))completionBlock {
    __block NSError *error;
    [self createBundleFolder:error];
    if (error) {
        completionBlock(error);
        return;
    }

    dispatch_group_t group = dispatch_group_create();

    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    NSArray *resources = self.downloadableBundle.resources;
    
    if ([resources count] == 0) {
        completionBlock(error);
        return;
    }
    
    for (NSString *resourcePath in resources) {
        dispatch_group_enter(group);
        [requestManager GET:resourcePath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self saveDataIntoBundleFolder:operation.responseData withName:[resourcePath lastPathComponent]];
            dispatch_group_leave(group);
        } failure:^(AFHTTPRequestOperation *operation, NSError *downloadError) {
            if (!error) {
                error = downloadError;
            }            
            [requestManager.operationQueue cancelAllOperations];
            dispatch_group_leave(group);
        }];
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        NSLog(@"ended downloading everything");
        if (completionBlock) {
            completionBlock(error);
        }
    });
}

- (void)saveDataIntoBundleFolder:(NSData *)data withName:(NSString *)name
{
    [data writeToFile:[self.bundleFolderPath stringByAppendingPathComponent:name] atomically:YES];
}

- (NSString *)bundleFolderPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:self.rootFolder];
    return [dataPath stringByAppendingPathComponent:self.downloadableBundle.uid];
}

- (void)createBundleFolder:(NSError *)error
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.bundleFolderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.bundleFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

@end
