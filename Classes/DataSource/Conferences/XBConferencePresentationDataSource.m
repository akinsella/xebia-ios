//
// Created by Simone Civetta on 22/02/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferencePresentationDataSource.h"
#import "XBLocalJsonDataLoader.h"
#import "XBJsonToArrayDataMapper.h"
#import "XBConferencePresentation.h"
#import "XBReloadableArrayDataSource+protected.h"
#import "XBConferencePresentationDetail.h"

@implementation XBConferencePresentationDataSource

- (instancetype)initWithResourcePath:(NSString *)resourcePath {
    self = [super init];
    if (self) {
        self.dataLoader = [XBLocalJsonDataLoader dataLoaderWithResourcePath:resourcePath];
        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:nil typeClass:[XBConferencePresentationDetail class]];
    }

    return self;
}

+ (instancetype)dataSourceWithResourcePath:(NSString *)resourcePath {
    return [[self alloc] initWithResourcePath:resourcePath];
}

- (void)loadPresentationWithId:(NSNumber *)presentationIdentifier callback:(void (^)(XBConferencePresentationDetail *))callback {
    [self loadDataWithCallback:^{

        for (int i = 0; i < [self count]; i++) {
            if ([[(XBConferencePresentation *) self[i] identifier] isEqualToNumber:presentationIdentifier]) {
                if (callback) {
                    callback(self[i]);
                    return;
                }
                break;
            }
        }
        if (callback) {
            callback(nil);
        }
    }];
}

@end