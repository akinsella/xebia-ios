//
//  XBDownloadableBundleDownloaderTest.m
//  Xebia
//
//  Created by Simone Civetta on 25/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <SenTestingKitAsync/SenTestingKitAsync.h>
#import "XBDownloadableBundleDownloader.h"
#import "XBConference.h"
#import "XBDownloadableBundleDownloader+Protected.h"

#define kNetworkTimeout 30.0f

@interface XBDownloadableBundleDownloaderTest : SenTestCase @end

@implementation XBDownloadableBundleDownloaderTest

- (void)setUp
{
    [self removeAllFilesInBundleRootDirectory];
}

- (void)testCreateBundleFolder
{
    XBConference *conference = [[XBConference alloc] initWithUid:@"C1"];
    XBDownloadableBundleDownloader *cdm = [XBDownloadableBundleDownloader downloaderWithDownloadableBundle:conference];
    [cdm createBundleFolder:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *conferenceDir = [[documentsDirectory stringByAppendingPathComponent:[cdm.class rootFolder]] stringByAppendingPathComponent:conference.uid];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    STAssertTrue([fileManager fileExistsAtPath:conferenceDir isDirectory:nil], nil);
}

- (void)testBundleFolderPath
{
    XBConference *conference = [[XBConference alloc] initWithUid:@"C1"];
    XBDownloadableBundleDownloader *cdm = [XBDownloadableBundleDownloader downloaderWithDownloadableBundle:conference];
    NSString *targetFolder = [[cdm.class rootFolder] stringByAppendingPathComponent:@"C1"];
    STAssertTrue([[cdm bundleFolderPath] hasSuffix:targetFolder], nil);
}

- (void)testRootFolderPath
{
    XBConference *conference = [[XBConference alloc] initWithUid:@"C1"];
    XBDownloadableBundleDownloader *cdm = [XBDownloadableBundleDownloader downloaderWithDownloadableBundle:conference];
    STAssertTrue([[cdm.class rootFolderPath] hasSuffix:[cdm.class rootFolder]], nil);
}

- (void)testDownload
{
    XBConference *conference = [[XBConference alloc] initWithUid:@"C1"];
    XBDownloadableBundleDownloader *cdm = [XBDownloadableBundleDownloader downloaderWithDownloadableBundle:conference];
    __block NSError *anError;
    [cdm downloadAllResources:^(NSError *error) {
        anError = error;
        STSuccess();
    }];
    STFailAfter(kNetworkTimeout, @"Expected response before timeout");
    STAssertNil(anError, nil);
}

- (void)removeAllFilesInBundleRootDirectory
{
    XBDownloadableBundleDownloader *cdm = [XBDownloadableBundleDownloader downloaderWithDownloadableBundle:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *directory = [documentsDirectory stringByAppendingPathComponent:[cdm.class rootFolder]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    for (NSString *file in files) {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
        if ([fileManager contentsOfDirectoryAtPath:fullPath error:nil])
            [fileManager removeItemAtPath:fullPath error:nil];
    }
}

- (void)tearDown {
}

@end
