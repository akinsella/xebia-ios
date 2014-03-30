//
// Created by Simone Civetta on 30/03/14.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XBConferenceRatingSendingService.h"
#import "XBHttpClient.h"
#import "XBConferenceRatingHttpQueryParamBuilder.h"


@implementation XBConferenceRatingSendingService

+ (id)dataSourceWithHttpClient:(XBHttpClient *)httpClient ratings:(NSArray *)ratings {
    return [[self alloc] initWithHttpClient:httpClient ratings:ratings];
}

- (id)initWithHttpClient:(XBHttpClient *)httpClient ratings:(NSArray *)ratings {
    self = [super init];
    if (self) {
        /*
        self.dataLoader = [XBHttpJsonDataLoader dataLoaderWithHttpClient:httpClient
                                                   httpQueryParamBuilder:[XBConferenceRatingHttpQueryParamBuilder builderWithRatings:ratings]
                                                            resourcePath:resourcePath];

        self.dataMapper = [XBJsonToArrayDataMapper mapperWithRootKeyPath:rootKeyPath typeClass:classType];
        */
        //TODO: implement
    }

    return self;
}

@end