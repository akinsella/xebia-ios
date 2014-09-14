//
// Created by Alexis Kinsella on 28/03/2014.
// Copyright (c) 2014 Xebia. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import "XBConferenceRatingUploader.h"
#import "XBHttpClient.h"
#import "XBConference.h"
#import "XBAppDelegate.h"
#import "AFURLResponseSerialization.h"
#import "XBConferenceRatingHttpQueryParamBuilder.h"
#import "XBLogging.h"
#import "XBConference.h"

@interface XBConferenceRatingUploader()

@property (nonatomic, strong) XBConference *conference;
@property (nonatomic, strong) NSArray *ratings;
@property (nonatomic, strong) XBHttpClient *httpClient;

@end


@implementation XBConferenceRatingUploader

- (instancetype)initWithRatings:(NSArray *)ratings conference:(XBConference *)conference httpClient:(XBHttpClient *)httpClient {
    self = [super init];
    if (self) {
        self.ratings = ratings;
        self.httpClient = httpClient;
        self.conference = conference;
    }

    return self;
}

+ (instancetype)uploaderWithRatings:(NSArray *)ratings conference:(XBConference *)conference httpClient:(XBHttpClient *)httpClient {
    return [[self alloc] initWithRatings:ratings conference:conference httpClient:httpClient];
}

- (void)uploadRatingsWithSuccess:(void (^)(id responseObject))success failure:(void(^)(id responseObject, NSError *error))failure {

    XBConferenceRatingHttpQueryParamBuilder *builder = [XBConferenceRatingHttpQueryParamBuilder builderWithRatings:self.ratings];

    id ratingArray = [builder build];

    NSString *resourcePath = [NSString stringWithFormat:@"/api/v1/conferences/%@/rating", self.conference.identifier];

    [self.httpClient executePostJsonRequestWithPath:resourcePath
                                         parameters:ratingArray
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonFetched) {
                                                success(jsonFetched);
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonFetched) {
                                                failure(jsonFetched, error);
                                            }];
}

@end