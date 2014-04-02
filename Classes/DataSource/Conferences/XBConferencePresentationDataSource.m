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

- (void)loadPresentationWithId:(NSString *)presentationIdentifier callback:(void (^)(XBConferencePresentationDetail *))callback {
    [self loadDataWithCallback:^{

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (int i = 0; i < [self count]; i++) {
                if ([[(XBConferencePresentation *) self[i] identifier] isEqualToString:presentationIdentifier]) {
                    if (callback) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(self[i]);
                        });
                        return;
                    }
                    break;
                }
            }
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil);
                });
            }
        });
    }];
}

@end