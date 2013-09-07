//
// Created by akinsella on 01/04/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XBDictionaryDataMerger.h"
#import <SenTestingKit/SenTestingKit.h>
#import "XBBundleJsonDataLoader.h"

@interface XBDictionaryDataMergerTest : SenTestCase @end

@implementation XBDictionaryDataMergerTest

-(void)testMerger {

    XBBundleJsonDataLoader *dataLoaderDest = [XBBundleJsonDataLoader dataLoaderWithResourcePath:@"wp-author-index-p1" resourceType:@"json"];
    XBBundleJsonDataLoader *dataLoaderSrc = [XBBundleJsonDataLoader dataLoaderWithResourcePath:@"wp-author-index-p2" resourceType:@"json"];

    __block NSDictionary *dataDest;
    __block NSDictionary *dataSrc;

    [dataLoaderSrc loadDataWithSuccess:^(NSDictionary * data) { dataSrc = data; } failure:^(NSError *error) { }];
    [dataLoaderDest loadDataWithSuccess:^(NSDictionary * data) { dataDest = data; } failure:^(NSError *error) { }];

    XBDictionaryDataMerger *dataMerger = [XBDictionaryDataMerger dataMergerWithRootKeyPath:@"authors"];

    NSDictionary * result = [dataMerger mergeDataFromSource:dataSrc toDest:dataDest];

    NSArray *authors = result[@"authors"];
    STAssertEquals(authors.count, 60U, nil);
}

@end