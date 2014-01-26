//
//  XBDownloadableBundleDownloader.h
//  Xebia
//
//  Created by Simone Civetta on 25/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBConference;
@protocol XBDownloadableBundle;

@interface XBDownloadableBundleDownloader : NSObject

+ (instancetype)downloaderWithDownloadableBundle:(id <XBDownloadableBundle>)downloadableBundle;

+ (NSString *)rootFolder;

+ (NSString *)rootFolderPath;

- (NSString *)bundleFolderPath;

- (void)downloadAllResources:(void (^)(NSError *error))completionBlock;

@end
