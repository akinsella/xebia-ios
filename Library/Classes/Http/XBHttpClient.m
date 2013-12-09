//
// Created by akinsella on 18/03/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AFNetworking/AFNetworking.h>
#import "XBHttpClient.h"
#import "XBLogging.h"

@interface XBHttpClient()

@property(nonatomic, strong)NSString *baseUrl;
@property(nonatomic, strong)AFHTTPRequestOperationManager *operationManager;

@end

@implementation XBHttpClient

+(id)httpClientWithBaseUrl:(NSString *)baseUrl {
    return [[XBHttpClient alloc] initWithBaseUrl:baseUrl];
}

-(id)initWithBaseUrl:(NSString *)baseUrl {
    self = [super init];

    if (self) {
        self.baseUrl = baseUrl;
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
//        self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }

    return self;
}

- (void)executeGetJsonRequestWithPath:(NSString *)path
                           parameters:(NSDictionary *)parameters
                              success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id jsonFetched))successCb
                              failure: (void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonFetched))errorCb {

    AFHTTPRequestOperation *operation = [self.operationManager GET: path parameters: parameters
                                                           success:^(AFHTTPRequestOperation *operation, id json) {
                                                               XBLogDebug(@"json: %@", json);

                                                               if (successCb) {
                                                                   successCb(operation.request, operation.response, json);
                                                               }
                                                           }
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               XBLogWarn(@"Error: %@, json: %@", error);

                                                               if (errorCb) {
                                                                   errorCb(operation.request, operation.response, error, operation.responseObject);
                                                               }
                                                           }
    ];

    [operation start];
}

- (void)executePostJsonRequestWithPath:(NSString *)path
                           parameters:(NSDictionary *)parameters
                              success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id jsonFetched))successCb
                              failure: (void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonFetched))errorCb {

    AFHTTPRequestOperation *operation = [self.operationManager POST: path parameters: parameters
                                                           success:^(AFHTTPRequestOperation *operation, id json) {
                                                               XBLogDebug(@"json: %@", json);

                                                               if (successCb) {
                                                                   successCb(operation.request, operation.response, json);
                                                               }
                                                           }
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               XBLogWarn(@"Error: %@, response object: %@", error, operation.responseObject);

                                                               if (errorCb) {
                                                                   errorCb(operation.request, operation.response, error, operation.responseObject);
                                                               }
                                                           }
    ];

    [operation start];
}

@end