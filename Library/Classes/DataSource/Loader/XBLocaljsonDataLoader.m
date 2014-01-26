//
//  XBLocalJsonDataLoader.m
//  Xebia
//
//  Created by Simone Civetta on 26/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBLocalJsonDataLoader.h"
#import "XBLogging.h"

@interface XBLocalJsonDataLoader()

@property (nonatomic, strong) NSString *resourcePath;

@end

@implementation XBLocalJsonDataLoader

+ (instancetype)dataLoaderWithResourcePath:(NSString *)resourcePath {
    return [[self alloc] initWithResourcePath:resourcePath];
}

- (instancetype)initWithResourcePath:(NSString *)resourcePath {
    self = [super init];
    if (self) {
        self.resourcePath = resourcePath;
    }

    return self;
}

- (void)loadDataWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSError *error;
    NSString *jsonLoaded = [NSString stringWithContentsOfFile:self.resourcePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        failure(error);
        return;
    }

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [jsonLoaded dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: &error];

    if (!error) {
        XBLogDebug(@"Json loaded from bundle: %@", json);
        success(json);
    }
    else {
        failure(error);
    }

}

@end
