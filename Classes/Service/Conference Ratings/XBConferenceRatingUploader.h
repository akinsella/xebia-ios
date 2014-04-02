//
// Created by Alexis Kinsella on 28/03/2014.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XBHttpClient;
@class XBConference;


@interface XBConferenceRatingUploader : NSObject

- (instancetype)initWithRatings:(NSArray *)ratings conference:(XBConference *)conference httpClient:(XBHttpClient *)httpClient;
+ (instancetype)uploaderWithRatings:(NSArray *)ratings conference:(XBConference *)conference httpClient:(XBHttpClient *)httpClient;
- (void)uploadRatingsWithSuccess:(void (^)(id responseObject))success failure:(void (^)(id responseObject, NSError *error))failure;

@end